{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  tomli,
  tomli-w,
  types-pyyaml,
  types-toml,
  urllib3,
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.25.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = pname;
    tag = version;
    hash = "sha256-Y7q1tN4bQmGV9sryMJRXi1ztoACHdBb0Sa4c35E1Nps=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    requests
    types-pyyaml
    types-toml
    urllib3
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
    tomli-w
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "responses" ];

  meta = with lib; {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    changelog = "https://github.com/getsentry/responses/blob/${src.tag}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
