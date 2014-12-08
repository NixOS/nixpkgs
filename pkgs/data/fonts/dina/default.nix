{stdenv, fetchurl, unzip, bdftopcf, mkfontdir, mkfontscale}:

stdenv.mkDerivation rec {
  version = "2.92";
  name = "dina-font-${version}";

  src = fetchurl {
    url = "http://www.donationcoder.com/Software/Jibz/Dina/downloads/Dina.zip";
    sha256 = "1kq86lbxxgik82aywwhawmj80vsbz3hfhdyhicnlv9km7yjvnl8z";
  };

  buildInputs = [ unzip bdftopcf mkfontdir mkfontscale ];

  dontBuild = true;
  patchPhase = "sed -i 's/microsoft-cp1252/ISO8859-1/' *.bdf";
  preInstall = ''
    export _get_font_size() {
      _pt=$\{1%.bdf}
      _pt=$\{_pt#*-}
      echo $_pt
    }
  '';
  installPhase = ''

    for i in Dina_i400-*.bdf; do
        bdftopcf -t -o DinaItalic$(_get_font_size $i).pcf $i
    done
    for i in Dina_i700-*.bdf; do
        bdftopcf -t -o DinaBoldItalic$(_get_font_size $i).pcf $i
    done
    for i in Dina_r400-*.bdf; do
        bdftopcf -t -o DinaMedium$(_get_font_size $i).pcf $i
    done
    for i in Dina_r700-*.bdf; do
        bdftopcf -t -o DinaBold$(_get_font_size $i).pcf $i
    done
    gzip *.pcf

    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "A monospace bitmap font aimed at programmers.";
    longDescription = ''
      Dina is a monospace bitmap font, primarily aimed at programmers. It is
      relatively compact to allow a lot of code on screen, while (hopefully)
      clear enough to remain readable even at high resolutions.
    '';
    homepage = https://www.donationcoder.com/Software/Jibz/Dina/;
    downloadPage = https://www.donationcoder.com/Software/Jibz/Dina/;
    license = licenses.free;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.linux;
  };
}
