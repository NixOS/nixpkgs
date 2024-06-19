{ lib
, stdenv
, fetchFromGitLab
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libz";
  version = "1.2.8.2015.12.26-unstable-2018-03-31";

  src = fetchFromGitLab {
    owner = "sortix";
    repo = "libz";
    rev = "752c1630421502d6c837506d810f7918ac8cdd27";
    hash = "sha256-AQuZ0BOl1iP5Nub+tVwctlE2tfJe4Sq/KDGkjwBbsV4=";
  };

  outputs = [ "out" "dev" ];
  outputDoc = "dev"; # single tiny man3 page

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "libz-";
  };

  meta = {
    homepage = "https://sortix.org/libz/";
    description = "A clean fork of zlib";
    license = [ lib.licenses.zlib ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
