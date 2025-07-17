{
  lib,
  buildPythonPackage,
  cacert,
  deprecated,
  eval-type-backport,
  fetchFromGitHub,
  griffe,
  hatchling,
  jinja2,
  litellm,
  platformdirs,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  redis,
}:

buildPythonPackage rec {
  pname = "banks";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "masci";
    repo = "banks";
    tag = "v${version}";
    hash = "sha256-aDcmrvrTNE+YfwFmcOvNBuCfzamvtkGE3EwybAucKuQ=";
  };

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  build-system = [ hatchling ];

  dependencies = [
    deprecated
    eval-type-backport
    griffe
    jinja2
    platformdirs
    pydantic
  ];

  optional-dependencies = {
    all = [
      litellm
      redis
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "banks" ];

  meta = {
    description = "Module that provides tools and functions to build prompts text and chat messages from generic blueprints";
    homepage = "https://github.com/masci/banks";
    changelog = "https://github.com/masci/banks/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
