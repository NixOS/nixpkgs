{ stdenv, fetchurl, pkgconfig, guile, guile-lib, cairo, expat }:

stdenv.mkDerivation rec {
  name = "guile-cairo-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "http://download.gna.org/guile-cairo/${name}.tar.gz";
    sha256 = "1f5nd9n46n6cwfl1byjml02q3y2hgn7nkx98km1czgwarxl7ws3x";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ guile cairo expat ];
  checkInputs = [ guile-lib ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Cairo bindings for GNU Guile";
    longDescription = ''
      Guile-Cairo wraps the Cairo graphics library for Guile Scheme.

      Guile-Cairo is complete, wrapping almost all of the Cairo API.  It is API
      stable, providing a firm base on which to do graphics work.  Finally, and
      importantly, it is pleasant to use.  You get a powerful and well
      maintained graphics library with all of the benefits of Scheme: memory
      management, exceptions, macros, and a dynamic programming environment.
    '';
    homepage = "http://home.gna.org/guile-cairo/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
