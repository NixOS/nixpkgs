{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  appdirs,
  jedi,
  prompt-toolkit,
  pygments,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.29";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-udYlGDrvk6Zz/DLL4cH8r1FBLnpPGVkFIc2syt8lGG4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    jedi
    prompt-toolkit
    pygments
  ];

  # no tests to run
  doCheck = false;

  pythonImportsCheck = [ "ptpython" ];

  meta = with lib; {
    description = "Advanced Python REPL";
    homepage = "https://github.com/prompt-toolkit/ptpython";
    changelog = "https://github.com/prompt-toolkit/ptpython/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
