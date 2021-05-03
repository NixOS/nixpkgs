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
  version = "0.6.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
    rev = "v${version}";
    sha256 = "1dm560hh6fl1waiwsq8m31apmvvwhc3y95bfdb7449bs8k96dmxq";
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
