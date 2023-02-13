{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vZS9IcHhP6x70xU/S8On3A6wl0uLwv3xqYnkdPblguU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorlog" ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
