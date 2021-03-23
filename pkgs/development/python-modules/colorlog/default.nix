{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "4.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WbUxYMYJAsQFzewo04NW4J1AaGZZBIiT4CbsvViVFrE=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorlog" ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
