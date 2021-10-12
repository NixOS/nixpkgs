{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf62a8e389d5660d0d22be17937b25b9abef9497ddc940197d1773aa1f604339";
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
