{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "aspell-0.60.5";
  
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.5.tar.gz;
    md5 = "17fd8acac6293336bcef44391b71e337";
  };
  
  buildInputs = [perl];

  patches = [
    # A patch that allows additional dictionary directories to be set
    # specified through the environment variable
    # ASPELL_EXTRA_DICT_DIRS (comma-separated).
    ./dict-path.patch
  ];

  meta = {
    description = "A spell checker for many languages";
    homepage = http://aspell.net/;
    license = "LGPL";
  };
}
