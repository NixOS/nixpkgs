{ lib
, stdenv
, fetchurl
, jdk21
, gradle
}:

stdenv.mkDerivation rec {
  pname = "wireshare";
  version = "7.0";

  src = fetchurl {
    url = "https://github.com/nmatavka/hermes-wireshare/releases/download/release/7.0/WireShare-7.0-source.tar.gz";
    sha256 = "07bzlbdq52vli2q11xzzl4z4cv0gb08dmdzb3sqnzyqynw3hpvgg";
  };

  nativeBuildInputs = [ gradle jdk21 ];

  buildPhase = ''
    export JAVA_HOME=${jdk21}
    ./gradlew --no-daemon wireShareJar
  '';

  installPhase = ''
    install -d $out/bin $out/share/wireshare
    install -m755 packaging/common/launchers/WireShare $out/bin/WireShare
    install -m644 WireShare.jar $out/share/wireshare/WireShare.jar
    install -Dm644 packaging/common/app/cx.hermes.WireShare.desktop $out/share/applications/cx.hermes.WireShare.desktop
    install -Dm644 packaging/common/app/cx.hermes.WireShare.metainfo.xml $out/share/metainfo/cx.hermes.WireShare.metainfo.xml
    cp -a packaging/common/icons $out/share/
  '';

  meta = with lib; {
    description = "Peer-to-peer sharing for Gnutella, BitTorrent, magnet, and eD2k";
    homepage = "https://github.com/nmatavka/hermes-wireshare";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "WireShare";
  };
}
