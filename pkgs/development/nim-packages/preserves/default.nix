{ lib, stdenv, buildNimPackage, fetchFromGitea, npeg }:

buildNimPackage rec {
  pname = "preserves";
  version = "20221102";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "${pname}-nim";
    rev = version;
    hash = "sha256-oRsq1ugtrOvTn23596BXRy71TQZ4h/Vv6JGqBTZdoKY=";
  };
  propagatedBuildInputs = [ npeg ];
  doCheck = !stdenv.isDarwin;
  meta = src.meta // {
    description = "Nim implementation of the Preserves data language";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
