{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gettext,
  mock,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "bagit";
  version = "1.9.0";
  pyproject = true;
  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchFromGitHub {
    owner = "LibraryOfCongress";
    repo = "bagit-python";
    tag = "v${version}";
    hash = "sha256-gHilCG07BXL28vBOaqvKhEQw+9l/AkzZRQxucBTEDos=";
  };

  nativeBuildInputs = [
    gettext
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];
  enabledTestPaths = [ "test.py" ];
  pythonImportsCheck = [ "bagit" ];

  meta = with lib; {
    description = "Python library and command line utility for working with BagIt style packages";
    mainProgram = "bagit.py";
    homepage = "https://libraryofcongress.github.io/bagit-python/";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ veprbl ];
  };
}
