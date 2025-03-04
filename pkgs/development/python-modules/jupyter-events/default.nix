{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonOlder,

  # build
  hatchling,

  # runtime
  jsonschema,
  python-json-logger,
  pyyaml,
  referencing,
  rfc3339-validator,
  rfc3986-validator,
  traitlets,

  # optionals
  click,
  rich,

  # tests
  pytest-asyncio,
  pytest-console-scripts,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-events";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_events";
    tag = "v${version}";
    hash = "sha256-e+BxJc/i5lpljvv6Uwqwrog+nLJ4NOBSqd47Q7DELOE=";
  };

  patches = [
    # https://github.com/jupyter/jupyter_events/pull/110
    (fetchpatch2 {
      name = "python-json-logger-compatibility.patch";
      url = "https://github.com/jupyter/jupyter_events/commit/6704ea630522f44542d83608f750da0068e41443.patch";
      hash = "sha256-PfmOlbXRFdQxhM3SngjjUNsiueuUfCO7xlyLDGSnzj4=";
    })
  ];

  build-system = [ hatchling ];

  dependencies = [
    jsonschema
    python-json-logger
    pyyaml
    referencing
    rfc3339-validator
    rfc3986-validator
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

  meta = {
    changelog = "https://github.com/jupyter/jupyter_events/releases/tag/v${version}";
    description = "Configurable event system for Jupyter applications and extensions";
    mainProgram = "jupyter-events";
    homepage = "https://github.com/jupyter/jupyter_events";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
