{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pyhumps,
  quart,
  msgspec,
  attrs,
  pytestCheckHook,
  pytest-asyncio,
  pydantic,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "quart-schema";
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-schema";
    tag = finalAttrs.version;
    hash = "sha256-U42UUDqix/397y332XWf9S5TFso7aEKTF4oIXh/gEtc=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    pyhumps
    quart
    msgspec
    attrs
  ];

  pythonImportsCheck = [
    "quart"
    "quart_schema"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pydantic
    hypothesis
  ];

  preCheck = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--no-cov-on-fail" ""
  '';

  meta = {
    description = "Create subcommand-based CLI programs with docopt";
    homepage = "https://github.com/pgjones/quart-schema";
    changelog = "https://github.com/pgjones/quart-schema/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
