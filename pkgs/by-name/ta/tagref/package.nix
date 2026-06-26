{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tagref";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "tagref";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KaLJZysinEMTYr7Nsp/nbWpx3sze2sT4cyfcYiAC5yY=";
  };

  cargoHash = "sha256-aL84/XHKH+TIsvS1Bud7RYvyMP5VAJaAi5bhjxAa7uI=";

  meta = {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yusdacra ];
    platforms = lib.platforms.unix;
    mainProgram = "tagref";
  };
})
