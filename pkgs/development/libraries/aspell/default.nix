{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "aspell-0.60.5";
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.5.tar.gz;
    md5 = "17fd8acac6293336bcef44391b71e337";
  };

  buildInputs = [perl];
}
