{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "alda";
  version = "2.2.0";

  src_alda = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${version}/client/linux-amd64/alda";
    sha256 = "0z3n81fmv3fxwgr641r6jjn1dmi5d3rw8d6r8jdfjhgpxanyi9a7";
  };

  src_player = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${version}/player/non-windows/alda-player";
    sha256 = "11kji846hbn1f2w1s7rc1ing203jkamy89j1jmysajvirdpp8nha";
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
