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
  version = "2.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "python";
    tag = "v${version}";
    hash = "sha256-wumJ8kpr+C2pdw8jYf+IqYTdSB6Iy37yZqPKycYmOSs=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    matplotlib = [ matplotlib ];
    pygments = [ pygments ];
    rich = [ rich ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

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
