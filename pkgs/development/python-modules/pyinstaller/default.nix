{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # native dependencies
  zlib,

  # dependencies
  altgraph,
  macholib,
  packaging,
  pyinstaller-hooks-contrib,

  # tests
  binutils,
  glibc,
  pyinstaller,
  testers,
}:

buildPythonPackage rec {
  pname = "pyinstaller";
  version = "6.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GDR5e+SM4bJgFa9oves8YabHUAE28E4Pxl5GgRXex3c=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib.dev ];

  dependencies = [
    altgraph
    packaging
    macholib
    pyinstaller-hooks-contrib
  ];

  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      glibc
      binutils
    ])
  ];

  pythonImportsCheck = [ "PyInstaller" ];

  passthru.tests.version = testers.testVersion {
    package = pyinstaller;
  };

  meta = {
    description = "A tool to bundle a python application with dependencies into a single package";
    homepage = "https://pyinstaller.org/";
    changelog = "https://pyinstaller.org/en/v${version}/CHANGES.html";
    downloadPage = "https://pypi.org/project/pyinstaller/";
    license = with lib.licenses; [
      mit
      asl20
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ h7x4 ];
    mainProgram = "pyinstaller";
  };
}
