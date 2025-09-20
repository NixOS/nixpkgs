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

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
  ];

  meta = {
    homepage = "https://dotat.at/prog/unifdef/";
    description = "Selectively remove C preprocessor conditionals";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
