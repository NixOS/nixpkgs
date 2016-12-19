{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "2.92";
  name = "dina-font-${version}";

  src = fetchurl {
    url = "http://www.donationcoder.com/Software/Jibz/Dina/downloads/Dina.zip";
    sha256 = "1kq86lbxxgik82aywwhawmj80vsbz3hfhdyhicnlv9km7yjvnl8z";
  };

  nativeBuildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase =
  ''
    mkdir -p $out/share/fonts
    cp *.bdf $out/share/fonts
  '';

  meta = with stdenv.lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''
      Dina is a monospace bitmap font, primarily aimed at programmers. It is
      relatively compact to allow a lot of code on screen, while (hopefully)
      clear enough to remain readable even at high resolutions.
    '';
    homepage = https://www.donationcoder.com/Software/Jibz/Dina/;
    downloadPage = https://www.donationcoder.com/Software/Jibz/Dina/;
    license = licenses.free;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.unix;
  };
}
