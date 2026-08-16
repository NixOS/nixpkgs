{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "t1utils";
  version = "1.42";

  src = fetchurl {
    url = "https://www.lcdf.org/type/t1utils-${finalAttrs.version}.tar.gz";
    sha256 = "YYd5NbGYcETd/0u5CgUgDKcWRnijVeFwv18aVVbMnyk=";
  };

  meta = {
    description = "Collection of simple Type 1 font manipulation programs";
    longDescription = ''
      t1utils is a collection of simple type-1 font manipulation programs.
      Together, they allow you to convert between PFA (ASCII) and PFB (binary)
      formats, disassemble PFA or PFB files into human-readable form,
      reassemble them into PFA or PFB format. Additionally you can extract font
      resources from a Macintosh font file or create a Macintosh Type 1 font
      file from a PFA or PFB font.
    '';
    homepage = "https://www.lcdf.org/type/";
    license = lib.licenses.mit-click;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
