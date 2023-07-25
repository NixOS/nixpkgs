{ lib, stdenv
, fetchurl
, fetchpatch
, libmysqlclient
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
  version = "5.0";
  pname = "glpk";

  src = fetchurl {
    url = "mirror://gnu/glpk/${pname}-${version}.tar.gz";
    sha256 = "sha256-ShAT7rtQ9yj8YBvdgzsLKHAzPDs+WoFu66kh2VvsbxU=";
  };

  buildInputs =
    [ libmysqlclient
    ] ++ lib.optionals withGmp [
      gmp
    ];

  configureFlags = lib.optionals withGmp [
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
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/error_recovery.patch?id=d3c1f607e32f964bf0cab877a63767c86fd00266";
      sha256 = "sha256-2hNtUEoGTFt3JgUvLH3tPWnz+DZcXNhjXzS+/V89toA=";
    })
  ];

  postPatch =
    # Do not hardcode the include path for libmysqlclient.
    ''
      substituteInPlace configure \
        --replace '-I/usr/include/mysql' '$(mysql_config --include)'
    '';

  doCheck = true;

  meta = with lib; {
    description = "The GNU Linear Programming Kit";

    longDescription =
      '' The GNU Linear Programming Kit is intended for solving large
         scale linear programming problems by means of the revised
         simplex method.  It is a set of routines written in the ANSI C
         programming language and organized in the form of a library.
      '';

    homepage = "https://www.gnu.org/software/glpk/";
    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ ] ++ teams.sage.members;
    mainProgram = "glpsol";
    platforms = platforms.all;
  };
}
