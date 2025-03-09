{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pygments,
  objprint,
  python-slugify,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "marko";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "marko";
    rev = "refs/tags/v${version}";
    hash = "sha256-KqdBYmlVs00atXy7MSsriRBnL7w13io2oFZ0IyJ2Om4=";
  };

  build-system = [
    pdm-backend
  ];

  optional-dependencies = {
    codehilite = [
      pygments
    ];
    repr = [
      objprint
    ];
    toc = [
      python-slugify
    ];
  };

  pythonImportsCheck = [
    "marko"
  ];

  nativeCheckInputs =
    [
      pytestCheckHook
    ]
    ++ optional-dependencies.toc
    ++ optional-dependencies.codehilite;

  meta = {
    changelog = "https://github.com/frostming/marko/blob/${src.rev}/CHANGELOG.md";
    description = "Markdown parser with high extensibility";
    homepage = "https://github.com/frostming/marko";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
