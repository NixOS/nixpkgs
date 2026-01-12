{
  lib,
  buildPythonPackage,
  fetchPypi,
  appdirs,
  jedi,
  prompt-toolkit,
  pygments,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.32";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EWUXeCNt6VxYK0JzcpTlCma6SiH6AcAJDqcIFa9Hj+A=";
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

  meta = {
    description = "Advanced Python REPL";
    homepage = "https://github.com/prompt-toolkit/ptpython";
    changelog = "https://github.com/prompt-toolkit/ptpython/blob/${version}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mlieberman85 ];
  };
}
