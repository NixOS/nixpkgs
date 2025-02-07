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
    hash = "sha256-X8sb/2mkhVp0jJpTk9uYSDhAVui4jHl355amRCnkNhA=";
  };

  buildInputs = [
    libpq
    sqlite
    libxml2
    libxslt
    openssl
  ];

  nimFlags = [ "--define:nimPreviewHashRef" ];

  meta = finalAttrs.src.meta // {
    description = "Utilities for the Syndicated Actor Model";
    homepage = "https://git.syndicate-lang.org/ehmry/syndicate_utils";
    maintainers = [ lib.maintainers.ehmry ];
    license = lib.licenses.unlicense;
  };
}) ./sbom.json
