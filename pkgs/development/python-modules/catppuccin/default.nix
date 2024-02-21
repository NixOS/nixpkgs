{ lib
, buildPythonPackage
, pythonOlder
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

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "python";
    rev = "v${version}";
    hash = "sha256-/RINDyO0cngDy9APqsFHBFBKi8aDf7Tah/IIFdXQURo=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  passthru.optional-dependencies = {
    pygments = [ pygments ];
    rich = [ rich ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pygments
    rich
  ];

  pythonImportsCheck = [ "catppuccin" ];

  meta = {
    description = "Soothing pastel theme for Python";
    homepage = "https://github.com/catppuccin/python";
    maintainers = with lib.maintainers; [ fufexan tomasajt ];
    license = lib.licenses.mit;
  };
}
