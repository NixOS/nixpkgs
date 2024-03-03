{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyrate-limiter
, requests
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "requests-ratelimiter";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JWCook";
    repo = "requests-ratelimiter";
    rev = "refs/tags/v${version}";
    hash = "sha256-JdxyBLrxXXb2KJ89qWl7yXP0fIafgnAguPGsN5iit8Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyrate-limiter
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "requests_ratelimiter" ];

  meta = with lib; {
    description = "Easy rate-limiting for python requests";
    homepage = "https://github.com/JWCook/requests-ratelimiter";
    changelog = "https://github.com/JWCook/requests-ratelimiter/blob/${src.rev}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
