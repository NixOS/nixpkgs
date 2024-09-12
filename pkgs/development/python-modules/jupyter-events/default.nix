{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build
  hatchling,

  # runtime
  jsonschema,
  python-json-logger,
  pyyaml,
  referencing,
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
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_events";
    rev = "refs/tags/v${version}";
    hash = "sha256-8aps8aNgXw+XbDgtCvWw+Ij1Cm1N0G+wcL35ySkofOk=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    jsonschema
    python-json-logger
    pyyaml
    referencing
    traitlets
  ] ++ jsonschema.optional-dependencies.format-nongpl;

  passthru.optional-dependencies = {
    cli = [
      click
      rich
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-console-scripts
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "jupyter_events" ];

  meta = with lib; {
    changelog = "https://github.com/jupyter/jupyter_events/releases/tag/v${version}";
    description = "Configurable event system for Jupyter applications and extensions";
    mainProgram = "jupyter-events";
    homepage = "https://github.com/jupyter/jupyter_events";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
