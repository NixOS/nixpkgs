{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "git-find-repos";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acroz";
    repo = "git-find-repos";
    rev = version;
    sha256 = "sha256-4TuZlt6XH4//DBHPuIMl/i3Tp6Uft62dGCTAuZ2rseE=";
  };

  build-system = [ setuptools-scm ];

  meta = {
    description = "Simple CLI tool for finding git repositories";
    homepage = "https://github.com/acroz/git-find-repos";
    license = lib.licenses.mit;
    mainProgram = "git-find-repos";
    maintainers = [ lib.maintainers.yajo ];
  };
}
