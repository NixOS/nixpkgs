{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "glpk-4.63";

  src = fetchurl {
    url = "mirror://gnu/glpk/${name}.tar.gz";
    sha256 = "1xp7nclmp8inp20968bvvfcwmz3mz03sbm0v3yjz8aqwlpqjfkci";
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
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
