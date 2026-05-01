{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asttokens,
  colorama,
  executing,
  pygments,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruns";
    repo = "icecream";
    tag = "v${version}";
    hash = "sha256-5PFl+DIsWGbh2VR+xW/L9fYBF0VCo1B10b+mzsq85As=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asttokens
    colorama
    executing
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renatoGarcia ];
  };
}
