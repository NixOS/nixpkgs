{
  lib,
  buildNimPackage,
  fetchFromGitea,
  libxml2,
  libxslt,
  openssl,
  postgresql,
  sqlite,
}:

buildNimPackage (finalAttrs: {
  pname = "syndicate_utils";
  version = "20240509";

  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "syndicate_utils";
    rev = finalAttrs.version;
    hash = "sha256-Sy6Ad0nNr/0y5W4z3SzlwfsA8hiXzlOPDOGdwbCYROs=";
  };

  buildInputs = [
    postgresql.out
    sqlite
    libxml2
    libxslt
    openssl
  ];

  lockFile = ./lock.json;

  meta = finalAttrs.src.meta // {
    description = "Utilities for the Syndicated Actor Model";
    homepage = "https://git.syndicate-lang.org/ehmry/syndicate_utils";
    maintainers = [ lib.maintainers.ehmry ];
    license = lib.licenses.unlicense;
  };
})
