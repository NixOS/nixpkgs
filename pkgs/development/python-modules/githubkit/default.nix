{ lib
, anyio
, buildPythonPackage
, fetchPypi
, httpx
, poetry-core
, pydantic
, pyjwt
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "githubkit";
  version = "0.10.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sKikL+761mBP7j+qugHKDQ0hVXT51FV8FYbB3ZJtweA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
    pydantic
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = [
      anyio
      pyjwt
    ];
    jwt = [
      pyjwt
    ];
    auth-app = [
      pyjwt
    ];
    auth-oauth-device = [
      anyio
    ];
    auth = [
      anyio
      pyjwt  
    ];
  };

  pythonImportsCheck = [
    "githubkit"
  ];

  meta = {
    description = "GitHub SDK for Python";
    homepage = "https://github.com/yanyongyu/githubkit";
    changelog = "https://github.com/yanyongyu/githubkit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
