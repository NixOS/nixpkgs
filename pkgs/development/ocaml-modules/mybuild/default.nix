{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "mybuild";
  version = "7";

  src = fetchFromGitHub {
    owner = "ygrek";
    repo = "mybuild";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-3NBu+8orypL7I8PBU7trI5DA4kbtg8wA/qzyCLUUWYM=";
  };

  meta = {
    description = "Small library and utility to generate version from VCS (git)";
    homepage = "https://github.com/ygrek/mybuild";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.niols ];
    platforms = lib.platforms.all;
  };
})
