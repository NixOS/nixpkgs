{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "alda";
  version = "2.2.3";

  src_alda = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${version}/client/linux-amd64/alda";
    hash = "sha256-cyOAXQ3ITIgy4QusjdYBNmNIzB6BzfbQEypvJbkbvWo=";
  };

  src_player = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${version}/player/non-windows/alda-player";
    hash = "sha256-HsX0mNWrusL2FaK2oK8xhmr/ai+3ZiMmrJk7oS3b93g=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      binPath = lib.makeBinPath [ jre ];
    in
    ''
      install -D $src_alda $out/bin/alda
      install -D $src_player $out/bin/alda-player

      wrapProgram $out/bin/alda --prefix PATH : $out/bin:${binPath}
      wrapProgram $out/bin/alda-player --prefix PATH : $out/bin:${binPath}
    '';

  meta = with lib; {
    description = "A music programming language for musicians";
    homepage = "https://alda.io";
    license = licenses.epl10;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };
}
