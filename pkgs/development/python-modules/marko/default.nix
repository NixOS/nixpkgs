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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "marko";
    tag = "v${version}";
    hash = "sha256-vrhixC8K+sk1yF8AZMHea7GhDhYNZg5P7juk+14tyMs=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.toc
  ++ optional-dependencies.codehilite;

  meta = {
    changelog = "https://github.com/frostming/marko/blob/${src.tag}/CHANGELOG.md";
    description = "Markdown parser with high extensibility";
    homepage = "https://github.com/frostming/marko";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
