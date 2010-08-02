{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wqy-zenhei-0.4.23-1";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/wqy/wqy-zenhei-0.4.23-1.tar.gz;
    sha256 = "138nn81ai240av0xvcq4ab3rl73n0qlj3gwr3a36i63ry8vdj5qm";
  };

  installPhase =
    ''
      ensureDir $out/share/fonts
      cp *.ttf $out/share/fonts
    '';

  meta = {
    description = "A (mainly) Chinese Unicode font";
  };
}

