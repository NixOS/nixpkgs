{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "glpk-4.46";

  src = fetchurl {
    url = "mirror://gnu/glpk/${name}.tar.gz";
    sha256 = "0hijkq44yxbq017wxqh441zz2rpdap6x1brp122i6s7hca147gpv";
  };

  doCheck = true;

  meta = {
    description = "The GNU Linear Programming Kit";

    longDescription =
      '' The GNU Linear Programming Kit is intended for solving large
         scale linear programming problems by means of the revised
         simplex method.  It is a set of routines written in the ANSI C
         programming language and organized in the form of a library.
      '';

    homepage = http://www.gnu.org/software/glpk/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
