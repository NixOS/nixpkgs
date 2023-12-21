{ buildPythonPackage
, fetchPypi
, hatch-vcs
, importlib-metadata
, lib
, manifestoo-core
, nix-update-script
, pytestCheckHook
, pythonOlder
, textual
, typer
, typing-extensions
}:

buildPythonPackage rec {
  pname = "manifestoo";
  version = "0.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gCGchc+fShBgt6fVJAx80+QnH+vxWo3jsIyePkFwhYE=";
  };

  nativeBuildInputs = [
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    manifestoo-core
    textual
    typer
  ]
  ++ typer.passthru.optional-dependencies.all
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A tool to reason about Odoo addons manifests";
    homepage = "https://github.com/acsone/manifestoo";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
