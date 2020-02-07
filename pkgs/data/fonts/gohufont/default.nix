{ stdenv, fetchurl, fetchFromGitHub
, mkfontdir, mkfontscale, bdf2psf, bdftopcf
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
    [ mkfontdir mkfontscale bdf2psf bdftopcf
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

    # convert bdf fonts to pcf and otb
    for i in *.bdf $src/hidpi/*.bdf; do
        name=$(basename $i .bdf)
        bdftopcf -o "$name.pcf" "$i"
        faketime -f "1970-01-01 00:00:01" fonttosfnt -v -o "$name.otb" "$i" || true
    done
  '';

  installPhase = ''
    # install the psf fonts (for the virtual console)
    fontDir="$out/share/consolefonts"
    mkdir -p "$fontDir"
    mv -t "$fontDir" psf/*.psf

    # install the pcf and otb fonts (for xorg applications)
    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv -t "$fontDir" *.pcf *.otb

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash     = "028mq0j6w76isv4ycj1jzx7ih9d9cz5012np7f1pf3bvnvw3ajw2";

  meta = with stdenv.lib; {
    description = ''
      A monospace bitmap font well suited for programming and terminal use
    '';
    homepage    = https://font.gohu.org/;
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ epitrochoid rnhmjoj ];
  };
}
