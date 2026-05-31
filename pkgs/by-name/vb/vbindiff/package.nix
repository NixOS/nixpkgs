{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vbindiff";
  version = "3.0_beta5";

  buildInputs = [ ncurses ];

  src = fetchurl {
    url = "https://www.cjmweb.net/vbindiff/vbindiff-${finalAttrs.version}.tar.gz";
    sha256 = "1f1kj4jki08bnrwpzi663mjfkrx4wnfpzdfwd2qgijlkx5ysjkgh";
  };

  meta = {
    description = "Terminal visual binary diff viewer";
    homepage = "https://www.cjmweb.net/vbindiff/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "vbindiff";
  };
})
