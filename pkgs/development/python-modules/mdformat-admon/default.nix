{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-admon";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-admon";
    tag = "v${version}";
    hash = "sha256-y0TNyje2OXBY4oo9kBePlqSZAU36vbQQKZUPm/u6DAc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
