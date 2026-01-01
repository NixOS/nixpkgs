{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-admon";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

<<<<<<< HEAD
  meta = {
    description = "Mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
=======
  meta = with lib; {
    description = "Mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
