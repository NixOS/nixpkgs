{ stdenv
, fetchurl
# Excerpt from glpk's INSTALL file:
# This feature allows the exact simplex solver to use the GNU MP
# bignum library. If it is disabled, the exact simplex solver uses the
# GLPK bignum module, which provides the same functionality as GNU MP,
# however, it is much less efficient.
, withGmp ? true
, gmp
}:

assert withGmp -> gmp != null;

stdenv.mkDerivation rec {
  version = "4.65";
  name = "glpk-${version}";

  src = fetchurl {
    url = "mirror://gnu/glpk/${name}.tar.gz";
    sha256 = "040sfaa9jclg2nqdh83w71sv9rc1sznpnfiripjdyr48cady50a2";
  };

  buildInputs = stdenv.lib.optionals withGmp [
    gmp
  ];

  configureFlags = stdenv.lib.optionals withGmp [
    "--with-gmp"
  ];

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

    maintainers = with stdenv.lib.maintainers; [ bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
