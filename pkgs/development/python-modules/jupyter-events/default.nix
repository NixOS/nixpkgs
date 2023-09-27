{ lib
, buildPythonPackage
, fetchFromGitHub

# build
, hatchling

# runtime
, jsonschema
, python-json-logger
, pyyaml
, traitlets

# optionals
, click
, rich

# tests
, pytest-asyncio
, pytest-console-scripts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-events";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_events";
    rev = "refs/tags/v${version}";
    hash = "sha256-hOx2/WiFpDjtmP+qC6Ew2VY4/gdvXuv2k76qtmS+61M=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    jsonschema
    python-json-logger
    pyyaml
    traitlets
  ]
  ++ jsonschema.optional-dependencies.format
  ++ jsonschema.optional-dependencies.format-nongpl;

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

  meta = with lib; {
    changelog = "https://github.com/jupyter/jupyter_events/releases/tag/v${version}";
    description = "Configurable event system for Jupyter applications and extensions";
    homepage = "https://github.com/jupyter/jupyter_events";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
