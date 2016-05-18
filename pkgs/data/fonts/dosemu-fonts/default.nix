{ stdenv, fetchurl, bdftopcf, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  name = "dosemu-fonts-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/dosemu/dosemu-${version}.tgz";
    sha256 = "0l1zwmw42mpakjrzmbygshcg2qzq9mv8lx42738rz3j9hrqzg4pw";
  };

  buildCommand = ''
    tar xf "$src" --anchored --wildcards '*/etc/*.bdf' '*/etc/dosemu.alias'
    fontPath="$out/share/fonts/X11/misc/dosemu"
    mkdir -p "$fontPath"
    for i in */etc/*.bdf; do
      fontOut="$out/share/fonts/X11/misc/dosemu/$(basename "$i" .bdf).pcf.gz"
      echo -n "Installing font $fontOut..." >&2
      ${bdftopcf}/bin/bdftopcf $i | gzip -c -9 > "$fontOut"
      echo " done." >&2
    done
    cp */etc/dosemu.alias "$fontPath/fonts.alias"
    cd "$fontPath"
    ${mkfontdir}/bin/mkfontdir
    ${mkfontscale}/bin/mkfontscale
  '';

  meta = {
    description = "Various fonts from the DOSEmu project";
  };
}
