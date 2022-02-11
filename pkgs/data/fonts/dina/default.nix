{ lib, stdenv, fetchurl, unzip
, bdftopcf, mkfontscale, fonttosfnt
}:

stdenv.mkDerivation {
  pname = "dina-font";
  version = "2.92";

  outputs = [ "out" "bdf" ];

  src = fetchurl {
    url = "http://www.donationcoder.com/Software/Jibz/Dina/downloads/Dina.zip";
    sha256 = "1kq86lbxxgik82aywwhawmj80vsbz3hfhdyhicnlv9km7yjvnl8z";
  };

  nativeBuildInputs =
    [ unzip bdftopcf mkfontscale fonttosfnt ];

  postPatch = ''
    sed -i 's/microsoft-cp1252/ISO8859-1/' *.bdf
  '';

  buildPhase = ''
    runHook preBuild

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

    for f in *.bdf; do
        name=$(newName "$f")
        bdftopcf -t -o "$name.pcf" "$f"
        fonttosfnt -v -o "$name.otb" "$f"
    done
    gzip -n -9 *.pcf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 644 -t "$out/share/fonts/misc" *.pcf.gz *.otb
    install -D -m 644 -t "$bdf/share/fonts/misc" *.bdf
    mkfontdir "$out/share/fonts/misc"
    mkfontdir "$bdf/share/fonts/misc"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A monospace bitmap font aimed at programmers";
    longDescription = ''
      Dina is a monospace bitmap font, primarily aimed at programmers. It is
      relatively compact to allow a lot of code on screen, while (hopefully)
      clear enough to remain readable even at high resolutions.
    '';
    homepage = "https://www.donationcoder.com/Software/Jibz/Dina/";
    downloadPage = "https://www.donationcoder.com/Software/Jibz/Dina/";
    license = licenses.free;
    maintainers = [ maintainers.prikhi ];
  };
}
