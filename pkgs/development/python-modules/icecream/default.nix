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
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruns";
    repo = "icecream";
    tag = "v${version}";
    hash = "sha256-8y109lTvZS50sBNzsgxxyIDf5w3gAou7RK1NxiGIziQ=";
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
