{
  lib,
  stdenv,
  fetchFromGitLab,
  libxml2,
  ncurses,
  bison,
  flex,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tiptop";
  version = "0-unstable-2026-05-21";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "rohou";
    repo = "tiptop";
    rev = "e91f7d6099c1f97f6492237cad7addea591b530b";
    hash = "sha256-doVgFir5J9h8k/AgOVk1vxTVzc66F6aZykFtTqinAco=";
  };

  postPatch = ''
    substituteInPlace ./configure --replace -lcurses -lncurses
  '';

  nativeBuildInputs = [
    flex
    bison
  ];
  buildInputs = [
    libxml2
    ncurses
  ];

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Performance monitoring tool for Linux";
    homepage = "https://gitlab.inria.fr/rohou/tiptop";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
