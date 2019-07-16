{ stdenv, fetchurl, fetchFromGitHub
, mkfontdir, mkfontscale, bdf2psf, bdftopcf
}:

stdenv.mkDerivation rec {
  name = "gohufont-${version}";
  version = "2.1";

  src = fetchurl {
    url = "http://font.gohu.org/${name}.tar.gz";
    sha256 = "10dsl7insnw95hinkcgmp9rx39lyzb7bpx5g70vswl8d6p4n53bm";
  };

  bdf = fetchFromGitHub {
    owner  = "hchargois";
    repo   = "gohufont";
    rev    = "cc36b8c9fed7141763e55dcee0a97abffcf08224";
    sha256 = "1hmp11mrr01b29phw0xyj4h9b92qz19cf56ssf6c47c5j2c4xmbv";
  };

  nativeBuildInputs = [ mkfontdir mkfontscale bdf2psf bdftopcf ];

  buildPhase = ''
    # convert bdf to psf fonts
    build=$(pwd)
    mkdir psf
    cd ${bdf2psf}/usr/share/bdf2psf
    for i in $bdf/*.bdf; do
      bdf2psf \
        --fb "$i" standard.equivalents \
        ascii.set+useful.set+linux.set 512 \
        "$build/psf/$(basename $i .bdf).psf"
    done
    cd $build

    # convert hidpi variant to pcf
    for i in $bdf/hidpi/*.bdf; do
        name=$(basename $i .bdf).pcf
        bdftopcf -o "$name" "$i"
    done
  '';

  installPhase = ''
    # install the psf fonts (for the virtual console)
    fontDir="$out/share/consolefonts"
    mkdir -p "$fontDir"
    mv -t "$fontDir" psf/*.psf

    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/misc"
    mkdir -p "$fontDir"
    mv -t "$fontDir" *.pcf.gz *.pcf

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash     = "0kl7k8idl0fnsap2c4j02i33z017p2s4gi2cgspy6ica46fczcc1";

  meta = with stdenv.lib; {
    description = ''
      A monospace bitmap font well suited for programming and terminal use
    '';
    homepage    = http://font.gohu.org/;
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ epitrochoid rnhmjoj ];
  };
}
