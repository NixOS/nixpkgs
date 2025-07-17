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

buildPythonPackage rec {
  pname = "quart-schema";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-schema";
    tag = version;
    hash = "sha256-FpjnhSTkjskCxT874ABrD3Zew4g4R977xaYvJhVTDxw=";
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
    homepage = "https://github.com/abingham/docopt-subcommands";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
