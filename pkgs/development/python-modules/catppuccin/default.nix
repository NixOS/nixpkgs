{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  matplotlib,
  pygments,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "catppuccin";
  version = "2.3.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-0+sbf2m0vJCf6EOl6DMqgtL35RJh+rehi/p0ylTPJK8=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

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
