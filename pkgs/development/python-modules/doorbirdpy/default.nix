{ lib
, buildPythonPackage
, fetchFromGitLab
, requests
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "2.2.2";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    rev = version;
    hash = "sha256-pgL4JegD1gANefp7jLYb74N9wgpkDgQc/Fe+NyLBrkA=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "doorbirdpy"
  ];

  meta = with lib; {
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
