{ lib, buildNimPackage, fetchFromGitea }:

buildNimPackage (finalAttrs: {
  pname = "syndicate_utils";
  version = "20231130";

  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "syndicate_utils";
    rev = finalAttrs.version;
    hash = "sha256-a9EjHSrLyWoP4qUQM+fRjZrNavQfT+SUO44pnPK1j/Q=";
  };

  lockFile = ./lock.json;

  meta = finalAttrs.src.meta // {
    description = "Utilities for the Syndicated Actor Model";
    homepage = "https://git.syndicate-lang.org/ehmry/syndicate_utils";
    maintainers = [ lib.maintainers.ehmry ];
    license = lib.licenses.unlicense;
  };
})
