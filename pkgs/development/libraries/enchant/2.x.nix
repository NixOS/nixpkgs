{ stdenv, fetchurl, aspell, pkgconfig, glib, hunspell, hspell, unittest-cpp }:

stdenv.mkDerivation rec {
  pname = "enchant";
  version = "2.2.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1p6a3qmrh8bjzds6x7rg9da0ir44gg804jzkf634h39wsa4vdmpm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib hunspell ];
  checkInputs = [ unittest-cpp ];
  propagatedBuildInputs = [ hspell aspell ]; # libtool puts it to la file

  enableParallelBuilding = true;

  doCheck = false; # https://github.com/AbiWord/enchant/issues/219

  meta = with stdenv.lib; {
    description = "Generic spell checking library";
    homepage = https://abiword.github.io/enchant/;
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
