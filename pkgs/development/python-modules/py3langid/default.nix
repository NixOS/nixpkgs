{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py3langid";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tN4B2tfnAfKdIWoJNeheCWzIZ1kD0j6oRFsrtfCQuW8=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # nixify path to the courlan binary in the test suite
  postPatch = ''
    substituteInPlace tests/test_langid.py --replace "'langid'" "'$out/bin/langid'"
  '';

  pythonImportsCheck = [ "py3langid" ];

  meta = with lib; {
    description = "Fork of the language identification tool langid.py, featuring a modernized codebase and faster execution times";
    mainProgram = "langid";
    homepage = "https://github.com/adbar/py3langid";
    changelog = "https://github.com/adbar/py3langid/blob/v${version}/HISTORY.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jokatzke ];
  };
}
