{
  lib,
  buildPythonPackage,
  setuptools-scm,
  fetchFromGitLab,
}:

buildPythonPackage rec {
  pname = "git-versioner";
  version = "7.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "alelec";
    repo = "__version__";
    rev = "v${version}";
    hash = "sha256-bnpuFJSd4nBXJA75V61kiB+nU5pUzdEAIScfKx7aaGU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "__version__" ];

<<<<<<< HEAD
  meta = {
    description = "Manage current / next version for project";
    homepage = "https://gitlab.com/alelec/__version__";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slotThe ];
=======
  meta = with lib; {
    description = "Manage current / next version for project";
    homepage = "https://gitlab.com/alelec/__version__";
    license = licenses.mit;
    maintainers = with maintainers; [ slotThe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
