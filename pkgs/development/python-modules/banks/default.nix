{
  lib,
  buildPythonPackage,
  cacert,
  deprecated,
  eval-type-backport,
  fetchFromGitHub,
  filetype,
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

buildPythonPackage (finalAttrs: {
  pname = "banks";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "masci";
    repo = "banks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rIN90R/olhBvOUlgh9KUV/1MxO814g561gTJam98Ny0=";
  };

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  build-system = [ hatchling ];

  dependencies = [
    deprecated
    eval-type-backport
    filetype
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
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "banks" ];

  meta = {
    description = "Module that provides tools and functions to build prompts text and chat messages from generic blueprints";
    homepage = "https://github.com/masci/banks";
    changelog = "https://github.com/masci/banks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
