{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  appdirs,
  importlib-metadata,
  jedi,
  prompt-toolkit,
  pygments,
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.27";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JLD9qUtz0cmaJ+b9DQi+by582nmi25lcfjx7ixJUutk=";
  };

  propagatedBuildInputs = [
    appdirs
    jedi
    prompt-toolkit
    pygments
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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
