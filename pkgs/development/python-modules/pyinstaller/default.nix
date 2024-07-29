{
  lib
, buildPythonPackage
, fetchPypi
, setuptools
, zlib
, altgraph
, packaging
, pyinstaller-hooks-contrib
, testers
, pyinstaller
, glibc
, binutils
, installShellFiles
}:

buildPythonPackage rec {
  pname = "pyinstaller";
  version = "6.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9KdcVS+swuKjcPHkIrlxteXNtAWP84zqAjWqIfwLN48=";
  };


  build-system = [ setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ zlib.dev ];

  dependencies = [
    altgraph
    packaging
    pyinstaller-hooks-contrib
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":"  (lib.makeBinPath [ glibc binutils ])
  ];

  postInstall = ''
    installManPage doc/pyinstaller.1 doc/pyi-makespec.1
  '';

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
