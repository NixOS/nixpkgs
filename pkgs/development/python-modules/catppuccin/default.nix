{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, pygments
, rich
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "catppuccin";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-/RINDyO0cngDy9APqsFHBFBKi8aDf7Tah/IIFdXQURo=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  optional-dependencies = {
    pygments = [ pygments ];
    rich = [ rich ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "catppuccin" ];

  meta = {
    description = "Soothing pastel theme for Python";
    homepage = "https://github.com/catppuccin/python";
    maintainers = with lib.maintainers; [ fufexan tomasajt ];
    license = lib.licenses.mit;
  };
}
