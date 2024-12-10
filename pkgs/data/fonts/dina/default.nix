{
  lib,
  stdenv,
  fetchzip,
  fontforge,
  bdftopcf,
  xorg,
}:

stdenv.mkDerivation {
  pname = "dina-font";
  version = "2.92";

  outputs = [
    "out"
    "bdf"
  ];

  src = fetchzip {
    url = "https://www.dcmembers.com/jibsen/download/61/?wpdmdl=61";
    hash = "sha256-JK+vnOyhAbwT825S+WKbQuWgRrfZZHfyhaMQ/6ljO8s=";
    extension = "zip";
    stripRoot = false;
  };

  nativeBuildInputs = [
    fontforge
    bdftopcf
    xorg.mkfontscale
    xorg.fonttosfnt
  ];

  buildPhase = ''
    runHook preBuild

    newName() {
      local name=''${1##*/}
      test "''${name:5:1}" = i && _it=Italic || _it=
      case ''${name:6:3} in
          400) _weight=Medium ;;
          700) _weight=Bold ;;
      esac
      _pt=''${1%.bdf}
      _pt=''${_pt#*-}
      echo "Dina$_weight$_it$_pt"
    }

    # Re-encode the provided BDF files from CP1252 to Unicode as fonttosfnt does
    # not support the former.
    # We could generate the PCF and OTB files with fontforge directly, but that
    # results in incorrect spacing in various places.
    for f in BDF/*.bdf; do
      basename=''${f##*/} basename=''${basename%.*}
      fontforge -lang=ff -c "Open(\"$f\"); Reencode(\"win\", 1); Reencode(\"unicode\"); Generate(\"$basename.bdf\")"
      mv "$basename"-*.bdf "$basename".bdf # remove the superfluous added size suffix
    done

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
    homepage = "https://www.dcmembers.com/jibsen/download/61/";
    license = licenses.free;
    maintainers = with maintainers; [
      prikhi
      ncfavier
    ];
  };
}
