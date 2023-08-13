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
  version = "0.7.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
    rev = "v${version}";
    hash = "sha256-Ka90n9Esv6tm310DjYeosBUhudeVoEJzt45L40+0GwQ=";
  };

  propagatedBuildInputs = [
    pyjwt
    ratelimit
    pytz
    requests
  ];

  nativeCheckInputs = [
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
