{stdenv, fetchurl, perl, which}:

stdenv.mkDerivation {
  name = "aspell-0.60.5";
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.5.tar.gz;
    md5 = "17fd8acac6293336bcef44391b71e337";
  };
  builder = ./builder.sh;

  buildInputs = [perl which];
  dictionaries =
    let en = fetchurl {
          url = ftp://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-6.0-0.tar.bz2;
          md5 = "16449e0a266e1ecc526b2f3cd39d4bc2";
        };
    in
      [ en ];
}
