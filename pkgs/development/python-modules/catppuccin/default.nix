{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  matplotlib,
  pygments,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "catppuccin";
  version = "2.4.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "python";
    tag = "v${version}";
    hash = "sha256-lQsJnzOnyDIUu1mbydiyfRwh0zCRGU35p0Kn2a3H/48=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    matplotlib = [ matplotlib ];
    pygments = [ pygments ];
    rich = [ rich ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "catppuccin" ];

  meta = {
    description = "Soothing pastel theme for Python";
    homepage = "https://github.com/catppuccin/python";
    maintainers = with lib.maintainers; [
      fufexan
      tomasajt
    ];
    license = lib.licenses.mit;
  };
}
