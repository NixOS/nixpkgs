{
  lib,
  stdenv,
  fetchFromGitHub,
  ghostscript_headless,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u2ps";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "arsv";
    repo = "u2ps";
    rev = finalAttrs.version;
    hash = "sha256-sa0CL47PwYVDykxzF8KeWhz7HXAX6jZ0AcfecD+aFyg=";
  };

  postPatch = ''
    # Fix for newer C standards
    substituteInPlace u2ps.h \
      --replace-fail "typedef unsigned char bool;" "#include <stdbool.h>"
  '';

  buildInputs = [ ghostscript_headless ];

  # gcc 15 defaults to C23 where bool is a keyword; u2ps does `typedef unsigned char bool;`
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  meta = {
    description = "Unicode text to postscript converter";
    homepage = "https://github.com/arsv/u2ps";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      U2ps is a text to postscript converter similar to a2ps,
      with emphasis on Unicode support.
    '';
    mainProgram = "u2ps";
    maintainers = [ lib.maintainers.athas ];
    platforms = lib.platforms.unix;
  };
})
