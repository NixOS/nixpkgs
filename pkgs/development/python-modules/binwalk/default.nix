{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  zlib,
  xz,
  gzip,
  bzip2,
  gnutar,
  p7zip,
  cabextract,
  cramfsprogs,
  cramfsswap,
  sasquatch,
  squashfsTools,
  matplotlib,
  nose,
  pycrypto,
  pyqtgraph,
  pyqt5,
  pythonOlder,
  visualizationSupport ? false,
}:

buildPythonPackage rec {
  pname = "binwalk${lib.optionalString visualizationSupport "-full"}";
  version = "2.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "v${version}";
    hash = "sha256-hlPbzqGRSXcIqlI+SNKq37CnnHd1IoMBNSjhyeAM1TE=";
  };

  patches = [
    # test_firmware_zip fails with 2.3.3 upgrade
    # https://github.com/ReFirmLabs/binwalk/issues/566
    (fetchpatch {
      url = "https://github.com/ReFirmLabs/binwalk/commit/dd4f2efd275c9dd1001130e82e0f985110cd2754.patch";
      sha256 = "1707n4nf1d1ay1yn4i8qlrvj2c1120g88hjwyklpsc2s2dcnqj9r";
      includes = [ "testing/tests/test_firmware_zip.py" ];
      revert = true;
    })
    # binwalk incompatible with Python 3.12
    # https://github.com/ReFirmLabs/binwalk/pull/668
    (fetchpatch {
      url = "https://github.com/ReFirmLabs/binwalk/commit/3e5c6887e840643fdbe7358de4bb31d726d0ce1b.patch";
      sha256 = "sha256-QhPIC2BKYeeCn2dNm9NeWpyUcIL1S+C/B3F55/nxrjw=";
    })
  ];

  propagatedBuildInputs =
    [
      zlib
      xz
      gzip
      bzip2
      gnutar
      p7zip
      cabextract
      squashfsTools
      xz
      pycrypto
    ]
    ++ lib.optionals visualizationSupport [
      matplotlib
      pyqtgraph
      pyqt5
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      cramfsprogs
      cramfsswap
      sasquatch
    ];

  # setup.py only installs version.py during install, not test
  postPatch = ''
    echo '__version__ = "${version}"' > src/binwalk/core/version.py
  '';

  doCheck = pythonOlder "3.12"; # nose requires imp module

  # binwalk wants to access ~/.config/binwalk/magic
  preCheck = ''
    HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [ nose ];

  pythonImportsCheck = [ "binwalk" ];

  meta = with lib; {
    homepage = "https://github.com/ReFirmLabs/binwalk";
    description = "Tool for searching a given binary image for embedded files";
    mainProgram = "binwalk";
    maintainers = [ maintainers.koral ];
    license = licenses.mit;
  };
}
