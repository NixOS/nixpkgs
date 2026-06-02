{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tedder";
    repo = "requests-aws4auth";
    tag = "v${version}";
    hash = "sha256-tRo38fdWqZmutGhWv8Hks+oFaLv770RlAHYgS3S6xJA=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  optional-dependencies = {
    httpx = [ httpx ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.httpx;

  pythonImportsCheck = [ "requests_aws4auth" ];

  meta = {
    description = "Amazon Web Services version 4 authentication for the Python Requests library";
    homepage = "https://github.com/sam-washington/requests-aws4auth";
    changelog = "https://github.com/tedder/requests-aws4auth/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ basvandijk ];
  };
}
