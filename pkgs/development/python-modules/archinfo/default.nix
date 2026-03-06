{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  backports-strenum,
  pypcode,
  # check inputs
  pytestCheckHook,
  pytest,
  pytest-xdist,
  # docs
  sphinxHook,
  furo,
  myst-parser,
  sphinx,
  sphinx-autodoc-typehints,
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.204";
  pyproject = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "archinfo";
    tag = "v${version}";
    hash = "sha256-/6hoY34hUZtB0SazpZe7CEfoWQoLxgtszMjbY1jw4fM=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [ backports-strenum ];

  optional-dependencies = {
    pcode = [ pypcode ];
  };

  nativeBuildInputs = [
    sphinxHook
    furo
    myst-parser
    sphinx
    sphinx-autodoc-typehints
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest
    pytest-xdist
  ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      fab
      misaka18931
    ];
  };
}
