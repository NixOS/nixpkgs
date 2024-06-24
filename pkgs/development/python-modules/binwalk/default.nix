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
  capstone,
  cabextract,
  cramfsprogs,
  cramfsswap,
  sasquatch,
  squashfsTools,
  matplotlib,
  pytestCheckHook,
  pycrypto,
  pyqtgraph,
  setuptools,
  visualizationSupport ? false,
}:

buildPythonPackage rec {
  pname = "binwalk${lib.optionalString visualizationSupport "-full"}";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OSPG";
    repo = "binwalk";
    rev = "v${version}";
    hash = "sha256-VApqQrVBV7w15Bpwc6Fd/cA1Ikqu7Ds8qu0TH68YVog=";
  };

  dependencies =
    [
      zlib
      xz
      gzip
      bzip2
      gnutar
      p7zip
      capstone
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

  build-system = [ setuptools ];

  # setup.py only installs version.py during install, not test
  postPatch = ''
    echo '__version__ = "${version}"' > src/binwalk/core/version.py
  '';

  # binwalk wants to access ~/.config/binwalk/magic
  preCheck = ''
    HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "binwalk" ];

  meta = {
    homepage = "https://github.com/OSPG/binwalk";
    description = "Tool for searching a given binary image for embedded files";
    mainProgram = "binwalk";
    maintainers = with lib.maintainers; [ koral ];
    license = lib.licenses.mit;
  };
}
