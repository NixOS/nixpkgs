{ stdenv, fetchurl, unzip
, bdftopcf, mkfontscale, fontforge
}:

stdenv.mkDerivation {
  pname = "dina-font";
  version = "2.92";

  src = fetchurl {
    url = "http://www.donationcoder.com/Software/Jibz/Dina/downloads/Dina.zip";
    sha256 = "1kq86lbxxgik82aywwhawmj80vsbz3hfhdyhicnlv9km7yjvnl8z";
  };

  nativeBuildInputs =
    [ unzip bdftopcf mkfontscale fontforge ];

  patchPhase = "sed -i 's/microsoft-cp1252/ISO8859-1/' *.bdf";

  buildPhase = ''
    newName() {
      test "''${1:5:1}" = i && _it=Italic || _it=
      case ''${1:6:3} in
        400) test -z $it && _weight=Medium ;;
        700) _weight=Bold ;;
      esac
      _pt=''${1%.bdf}
      _pt=''${_pt#*-}
      echo "Dina$_weight$_it$_pt"
    }

    # convert bdf fonts to pcf
    for i in *.bdf; do
      bdftopcf -t -o $(newName "$i").pcf "$i"
    done
    gzip -n -9 *.pcf

    # convert bdf fonts to otb
    for i in *.bdf; do
      fontforge -lang=ff -c "Open(\"$i\"); Generate(\"$(newName $i).otb\")"
    done
  '';

  installPhase = ''
    install -D -m 644 -t "$out/share/fonts/misc" *.pcf.gz
    install -D -m 644 -t "$bdf/share/fonts/misc" *.bdf
    install -D -m 644 -t "$otb/share/fonts/misc" *.otb
    mkfontdir "$out/share/fonts/misc"
    mkfontdir "$bdf/share/fonts/misc"
    mkfontdir "$otb/share/fonts/misc"
  '';

  outputs = [ "out" "bdf" "otb" ];

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
  };
}
