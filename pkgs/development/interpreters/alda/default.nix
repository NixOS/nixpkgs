{ lib, stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "alda";
  version = "1.4.4";

  src = fetchurl {
    url = "https://github.com/alda-lang/alda/releases/download/${version}/alda";
    sha256 = "sha256-zIq8coSh4B9VGrixkQfhySK7qhlFG2p7O0suvbiScKY=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/alda
    sed -i -e '1 s!java!${jre}/bin/java!' $out/bin/alda
  '';

  meta = with lib; {
    description = "A music programming language for musicians";
    homepage = "https://alda.io";
    license = licenses.epl10;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };

}
