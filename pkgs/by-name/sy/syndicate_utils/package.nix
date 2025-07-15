{
  lib,
  buildNimSbom,
  fetchFromGitea,
  libxml2,
  libxslt,
  openssl,
  libpq,
  sqlite,
}:

buildNimSbom (finalAttrs: {
  pname = "syndicate_utils";

  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "syndicate_utils";
    rev = finalAttrs.version;
    hash = "sha256-zHVL2A5mAZX73Xk6Pcs02wHCAVfsOYxDO8/yKX0FvBs=";
  };

  buildInputs = [
    libpq
    sqlite
    libxml2
    libxslt
    openssl
  ];

  meta = finalAttrs.src.meta // {
    description = "Utilities for the Syndicated Actor Model";
    homepage = "https://git.syndicate-lang.org/ehmry/syndicate_utils";
    maintainers = [ lib.maintainers.ehmry ];
    license = lib.licenses.unlicense;
  };
}) ./sbom.json
