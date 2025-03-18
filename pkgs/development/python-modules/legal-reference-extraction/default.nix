{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nltk,
}:

buildPythonPackage rec {
  pname = "legal-reference-extraction";
  version = "0-unstable-2021-01-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openlegaldata";
    repo = "legal-reference-extraction";
    rev = "c862ba02f7ee8bc363ecfebe53ec2b035e4da881";
    hash = "sha256-NmE0dJD43/94IajxxeQWnnaiTN4M7NNtSoZqLUc4V48=";
  };

  build-system = [ setuptools ];

  dependencies = [ nltk ];

  pythonRelaxDeps = [ "nltk" ];

  pythonImportsCheck = [ "refex.extractor" ];

  meta = {
    description = "legal reference extraction";
    homepage = "https://github.com/openlegaldata/legal-reference-extraction";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gm6k ];
  };
}
