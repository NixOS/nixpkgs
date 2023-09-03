{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, simpleeval
, wcmatch
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "1.26.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "refs/tags/v${version}";
    hash = "sha256-wM27HW5w8fDjHoGV+OGDTaO5SKJrq8fGKh1EPQt+wlo=";
  };

  propagatedBuildInputs = [
    simpleeval
    wcmatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "casbin"
  ];

  meta = with lib; {
    description = "Authorization library that supports access control models like ACL, RBAC and ABAC";
    homepage = "https://github.com/casbin/pycasbin";
    changelog = "https://github.com/casbin/pycasbin/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
