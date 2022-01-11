{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "alda";
  version = "2.0.6";

  src_alda = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${version}/client/linux-amd64/alda";
    sha256 = "1078hywl3gim5wfgxb0xwbk1dn80ls3i7y33n76qsdd4b0x0sn7i";
  };

  src_player = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${version}/player/non-windows/alda-player";
    sha256 = "1g7k2qnh4vcw63604z7zbvhbpn7l1v3m9mx4j4vywfq6qar1r6ck";
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
