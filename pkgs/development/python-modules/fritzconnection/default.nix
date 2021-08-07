{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, pytestCheckHook, requests }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.6.0";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = version;
    sha256 = "16sbv6ql6jd13lim88z8vl5205xppza10340bmq5m5f3lvzb7mpc";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fritzconnection" ];

  meta = with lib; {
    description = "Python-Tool to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
