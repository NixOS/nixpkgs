{ stdenv, fetchurl, aspell, pkgconfig, glib, hunspell, hspell }:

stdenv.mkDerivation rec {
  version = "1.6.1";
  pname = "enchant";

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/${pname}-1-6-1/${pname}-${version}.tar.gz";
    sha256 = "1xg3m7mniyqyff8qv46jbfwgchb6di6qxdjnd5sfir7jzv0dkw5y";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ aspell glib hunspell hspell ];

  meta = with stdenv.lib; {
    description = "Generic spell checking library";
    homepage = https://abiword.github.io/enchant;
    platforms = platforms.unix;
    badPlatforms = [ "x86_64-darwin" ];
    license = licenses.lgpl21;
  };
}
