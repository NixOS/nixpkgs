{ lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, pytz
, requests
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "datapoint";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "ejep";
    repo = "datapoint-python";
    rev = "v${version}";
    hash = "sha256-YC8KFTv6lnCqMfDw1LSova7XBgmKbR3TpPDAAbH9imw=";
  };

  propagatedBuildInputs = [
    appdirs
    pytz
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "datapoint" ];

  meta = {
    description = "Python interface to the Met Office's Datapoint API";
    homepage = "https://github.com/ejep/datapoint-python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
