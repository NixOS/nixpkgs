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
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CodaAxpYqvnb2nu4KF/XXoAae9J2IW/6vgN5AdS0Sew=";
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
