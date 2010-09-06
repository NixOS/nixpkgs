{ fetchurl, stdenv, guile, pkgconfig, cairo, guile_lib }:

stdenv.mkDerivation rec {
  name = "guile-cairo-1.4.0";

  src = fetchurl {
    url = "http://download.gna.org/guile-cairo/${name}.tar.gz";
    sha256 = "01wmpflfyxh239b5xvm41qn24z9k414klcqyh46r6xwvq2vd9mds";
  };

  buildInputs = [ guile pkgconfig cairo ]
    ++ stdenv.lib.optional doCheck guile_lib;

  doCheck = true;

  meta = {
    description = "Guile-Cairo, Cairo bindings for GNU Guile";

    longDescription =
      '' Guile-Cairo wraps the Cairo graphics library for Guile Scheme.

         Guile-Cairo is complete, wrapping almost all of the Cairo API.  It
         is API stable, providing a firm base on which to do graphics work.
         Finally, and importantly, it is pleasant to use.  You get a powerful
         and well-maintained graphics library with all of the benefits of
         Scheme: memory management, exceptions, macros, and a dynamic
         programming environment.
      '';

    license = "LGPLv2+";

    homepage = http://home.gna.org/guile-cairo/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
