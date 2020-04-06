{ stdenv, fetchurl, fetchFromGitHub
, mkfontscale, bdf2psf, bdftopcf
, fonttosfnt, libfaketime
}:

stdenv.mkDerivation rec {
  pname = "gohufont";
  version = "2.1";

  src = fetchFromGitHub {
    owner  = "hchargois";
    repo   = "gohufont";
    rev    = "cc36b8c9fed7141763e55dcee0a97abffcf08224";
    sha256 = "1hmp11mrr01b29phw0xyj4h9b92qz19cf56ssf6c47c5j2c4xmbv";
  };

  nativeBuildInputs =
    [ mkfontscale bdf2psf bdftopcf
      fonttosfnt libfaketime
    ];

  buildPhase = ''
    # convert bdf fonts to psf
    build=$(pwd)
    mkdir psf
    cd ${bdf2psf}/share/bdf2psf
    for i in $src/*.bdf; do
      name=$(basename $i .bdf)
      bdf2psf \
        --fb "$i" standard.equivalents \
        ascii.set+useful.set+linux.set 512 \
        "$build/psf/$name.psf"
    done
    cd $build

    # convert bdf fonts to pcf
    for i in *.bdf $src/hidpi/*.bdf; do
        name=$(basename $i .bdf)
        bdftopcf -o "$name.pcf" "$i"
    done

    # convert unicode bdf fonts to otb
    for i in *-uni*.bdf $src/hidpi/*-uni*.bdf; do
        name=$(basename $i .bdf)
        faketime -f "1970-01-01 00:00:01" \
        fonttosfnt -v -o "$name.otb" "$i"
    done
  '';

  installPhase = ''
    # install the psf fonts (for the virtual console)
    fontDir="$out/share/consolefonts"
    install -D -m 644 -t "$fontDir" psf/*.psf

    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/misc"
    install -D -m 644 -t "$fontDir" *.pcf
    mkfontdir "$fontDir"

    # install the otb fonts (for gtk applications)
    fontDir="$otb/share/fonts/misc"
    install -D -m 644 -t "$fontDir" *.otb
    mkfontdir "$fontDir"
  '';

  outputs = [ "out" "otb" ];

  meta = with stdenv.lib; {
    description = ''
      A monospace bitmap font well suited for programming and terminal use
    '';
    homepage    = https://font.gohu.org/;
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ epitrochoid rnhmjoj ];
  };
}
