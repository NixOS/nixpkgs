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
