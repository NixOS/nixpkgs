{ stdenv, fetchurl, aspell, pkgconfig, glib, hunspell, hspell }:

let
  version = "2.2.3";
  pname = "enchant";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0v87p1ls0gym95qirijpclk650sjbkcjjl6ssk059zswcwaykn5b";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib hunspell ];
  propagatedBuildInputs = [ hspell aspell ]; # libtool puts it to la file

  meta = with stdenv.lib; {
    description = "Generic spell checking library";
    homepage = https://abiword.github.io/enchant/;
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
