{ lib
, buildPythonPackage
, bzip2
, cabextract
, cramfsprogs
, cramfsswap
, fetchFromGitHub
, fetchpatch
, gnutar
, gzip
, matplotlib
, p7zip
, pycrypto
, pynose
, pyqtgraph
, sasquatch
, setuptools
, squashfsTools
, stdenv
, visualizationSupport ? false
, xz
, zlib
}:

buildPythonPackage rec {
  pname = "binwalk${lib.optionalString visualizationSupport "-full"}";
  version = "2.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "refs/tags/v${version}";
    hash = "sha256-hlPbzqGRSXcIqlI+SNKq37CnnHd1IoMBNSjhyeAM1TE=";
  };

  patches = [
    # test_firmware_zip fails with 2.3.3 upgrade
    # https://github.com/ReFirmLabs/binwalk/issues/566
    (fetchpatch {
      url = "https://github.com/ReFirmLabs/binwalk/commit/dd4f2efd275c9dd1001130e82e0f985110cd2754.patch";
      sha256 = "1707n4nf1d1ay1yn4i8qlrvj2c1120g88hjwyklpsc2s2dcnqj9r";
      includes = [
        "testing/tests/test_firmware_zip.py"
      ];
      revert = true;
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    bzip2
    cabextract
    gnutar
    gzip
    p7zip
    pycrypto
    squashfsTools
    xz
    xz
    zlib
  ] ++ lib.optionals visualizationSupport [
    matplotlib
    pyqtgraph
  ] ++ lib.optionals (!stdenv.isDarwin) [
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

  nativeCheckInputs = [
    pynose
  ];

  pythonImportsCheck = [
    "binwalk"
  ];

  meta = with lib; {
    description = "A tool for searching a given binary image for embedded files";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    changelog = "https://github.com/ReFirmLabs/binwalk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
