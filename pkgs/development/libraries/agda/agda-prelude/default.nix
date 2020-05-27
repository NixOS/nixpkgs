{ stdenv, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  version = "compat-2.6.0";
  pname = "agda-prelude";

  src = fetchFromGitHub {
    owner = "UlfNorell";
    repo = "agda-prelude";
    rev = version;
    sha256 = "0brg61qrf8izqav80qpx77dbdxvlnsxyy0v7hmlrmhg68b5lp38y";
  };

  preConfigure = ''
    cd test
    make everything
    mv Everything.agda ..
    cd ..
  '';

  everythingFile = "./Everything.agda";

  meta = with stdenv.lib; {
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    # broken since Agda 2.6.1
    broken = true;
    maintainers = with maintainers; [ mudri alexarice turion ];
  };
}
