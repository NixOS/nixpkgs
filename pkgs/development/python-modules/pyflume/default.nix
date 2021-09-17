{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyjwt
, ratelimit
, pytz
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyflume";
  version = "0.7.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
    rev = "v${version}";
    sha256 = "129sz33a270v120bzl9l98nmvdzn7ns4cf9w2v18lmzlldbyz2vn";
  };

  propagatedBuildInputs = [
    pyjwt
    ratelimit
    pytz
    requests
  ];

  checkInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyflume" ];

  meta = with lib; {
    description = "Python module to work with Flume sensors";
    homepage = "https://github.com/ChrisMandich/PyFlume";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
