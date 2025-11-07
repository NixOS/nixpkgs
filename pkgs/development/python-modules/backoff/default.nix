{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio_0,
  responses,
}:

buildPythonPackage rec {
  pname = "backoff";
  version = "2.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "litl";
    repo = "backoff";
    tag = "v${version}";
    hash = "sha256-g8bYGJ6Kw6y3BUnuoP1IAye5CL0geH5l7pTb3xxq7jI=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "backoff" ];

  meta = with lib; {
    description = "Function decoration for backoff and retry";
    homepage = "https://github.com/litl/backoff";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
