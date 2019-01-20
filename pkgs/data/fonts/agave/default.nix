{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "agave-${version}";
  version = "008";

  src = fetchurl {
    url = "https://github.com/agarick/agave/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0g50mqpffn4dq761vibaf8dwfkbcl5da1cc89qz6pq35ircipbns";
  };

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = https://b.agaric.net/page/agave;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

