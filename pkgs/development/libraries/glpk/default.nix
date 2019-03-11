{ stdenv
, fetchurl
, fetchpatch
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

  patches = [
    # GLPK makes it possible to customize its message printing behaviour. Sage
    # does that and needs to differentiate between printing regular messages and
    # printing errors. Unfortunately there is no way to tell and glpk upstream
    # rejected this patch. All it does is set the variable pointing to the error
    # file back to NULL before glpk calls abort(). In sage's case, abort won't
    # actually be called because the error handler jumps out of the function.
    # This shouldn't affect everybody else, since glpk just calls abort()
    # immediately afterwards anyways.
    # See the sage trac ticket for more details:
    # https://trac.sagemath.org/ticket/20710#comment:18
    (fetchpatch {
      name = "error_recovery.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/error_recovery.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "0z99z9gd31apb6x5n5n26411qzx0ma3s6dnznc4x61x86bhq31qf";
    })
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

    homepage = https://www.gnu.org/software/glpk/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ bjg timokau ];
    platforms = stdenv.lib.platforms.all;
  };
}
