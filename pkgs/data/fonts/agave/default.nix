{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "agave";
  version = "009";

  src = fetchurl {
    url = "https://github.com/agarick/agave/releases/download/v${version}/agave-r.ttf";
    sha256 = "05766gp2glm1p2vknk1nncxigq28hg8s58kjwsbn8zpwy8ivywpk";
  };

  sourceRoot = ".";

  unpackPhase = ":";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/
  '';

  meta = with stdenv.lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = https://b.agaric.net/page/agave;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

