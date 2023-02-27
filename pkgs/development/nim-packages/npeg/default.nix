{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "npeg";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "zevv";
    repo = pname;
    rev = version;
    hash = "sha256-EN3wTSa+WveO7V29A2lJgWLwIlHzQE8t7T2m4u7niMc=";
  };
  doCheck = true;
  meta = src.meta // {
    description = "NPeg is a pure Nim pattern matching library";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.mit;
  };
}
