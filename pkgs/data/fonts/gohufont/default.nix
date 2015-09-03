{ stdenv, fetchurl, mkfontdir, mkfontscale, bdf2psf }:

stdenv.mkDerivation rec {
  name = "gohufont-2.0";

  pcf = fetchurl {
    url = "http://font.gohu.org/gohufont-2.0.tar.gz";
    sha256 = "0vi87fvj3m52piz2k6vqday03cah6zvz3dzrvjch3qjna1i1nb7s";
  };

  bdf = fetchurl {
    url = "http://font.gohu.org/gohufont-bdf-2.0.tar.gz";
    sha256 = "0rqqavhqbs7pajcblg92mjlz2dxk8b60vgdh271axz7kjs2wf9mr";
  };

  buildInputs = [ mkfontdir mkfontscale bdf2psf ];

  unpackPhase = ''
    mkdir pcf bdf
    tar -xzf $pcf --strip-components=1 -C pcf
    tar -xzf $bdf --strip-components=1 -C bdf
  '';

  installPhase = ''
    # convert bdf to psf fonts
    sourceRoot="$(pwd)"
    mkdir psf

    cd "${bdf2psf}/usr/share/bdf2psf"
    for i in $sourceRoot/bdf/*.bdf; do
      bdf2psf --fb $i standard.equivalents \
                      ascii.set+useful.set+linux.set 512 \
                      "$sourceRoot/psf/$(basename $i .bdf).psf"
    done
    cd "$sourceRoot"

    # install the psf fonts (for the virtual console)
    fontDir="$out/share/consolefonts"
    mkdir -p "$fontDir"
    mv psf/*.psf "$fontDir"


    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv pcf/*.pcf.gz "$fontDir"

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  meta = with stdenv.lib; {
    description = ''
      A monospace bitmap font well suited for programming and terminal use
    '';
    homepage = http://font.gohu.org/;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ epitrochoid ];
    platforms = with platforms; linux;
  };
}
