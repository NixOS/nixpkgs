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

  meta = with lib; {
    description = "Manage current / next version for project";
    homepage = "https://gitlab.com/alelec/__version__";
    license = licenses.mit;
    maintainers = with maintainers; [ slotThe ];
  };
}
