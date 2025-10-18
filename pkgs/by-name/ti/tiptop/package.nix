{
  lib,
  stdenv,
  fetchurl,
  libxml2,
  ncurses,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tiptop";
  version = "2.3.2";

  src = fetchurl {
    url = "https://files.inria.fr/pacap/tiptop/tiptop-${finalAttrs.version}.tar.gz";
    hash = "sha256-oUsbWepIVoROJ7xOIhKbeQa4gVr69QolrGCZja/Mk6c=";
  };

  postPatch = ''
    substituteInPlace ./configure \
      --replace-fail -lcurses -lncurses
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

  meta = {
    description = "Performance monitoring tool for Linux";
    homepage = "https://team.inria.fr/pacap/software/tiptop";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
