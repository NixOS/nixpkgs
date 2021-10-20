{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "py-canary";
  version = "0.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "snjoetw";
    repo = pname;
    rev = version;
    sha256 = "0j743cc0wv7im3anx1vvdm79zyvw67swhc3zwwc1r8626dgnmxjr";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "canary" ];

  meta = with lib; {
    description = "Python package for Canary Security Camera";
    homepage = "https://github.com/snjoetw/py-canary";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
