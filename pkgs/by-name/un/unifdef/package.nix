{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "unifdef";
  version = "2.12";

  src = fetchurl {
    url = "https://dotat.at/prog/unifdef/unifdef-${version}.tar.xz";
    sha256 = "00647bp3m9n01ck6ilw6r24fk4mivmimamvm4hxp5p6wxh10zkj3";
  };

  patches = [
    # Fix build with gcc15
    # https://github.com/fanf2/unifdef/pull/19
    ./unifdef-fix-build-with-gcc15.patch
  ];

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
  ];

  meta = with lib; {
    homepage = "https://dotat.at/prog/unifdef/";
    description = "Selectively remove C preprocessor conditionals";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
