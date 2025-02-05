{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  jsonschema,
  pytest-asyncio,
  pytest-console-scripts,
  pytestCheckHook,
  python-json-logger,
  pythonOlder,
  pyyaml,
  referencing,
  rich,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyter-events";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_events";
    tag = "v${version}";
    hash = "sha256-e+BxJc/i5lpljvv6Uwqwrog+nLJ4NOBSqd47Q7DELOE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jsonschema
    python-json-logger
    pyyaml
    referencing
    traitlets
  ] ++ jsonschema.optional-dependencies.format-nongpl;

  optional-dependencies = {
    cli = [
      click
      rich
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-console-scripts
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "jupyter_events" ];

  meta = with lib; {
    description = "Configurable event system for Jupyter applications and extensions";
    homepage = "https://github.com/jupyter/jupyter_events";
    changelog = "https://github.com/jupyter/jupyter_events/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "jupyter-events";
  };
}
