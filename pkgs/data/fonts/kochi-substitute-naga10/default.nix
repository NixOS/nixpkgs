{ lib, fetchzip }:

let version = "20030809";
in
fetchzip {
  name = "kochi-substitute-naga10-${version}";

  url = "mirror://osdn/efont/5411/kochi-substitute-${version}.tar.bz2";

  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*/kochi-gothic-subst.ttf $out/share/fonts/truetype/kochi-gothic-subst-naga10.ttf
    mv $out/*/kochi-mincho-subst.ttf $out/share/fonts/truetype/kochi-mincho-subst-naga10.ttf
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  sha256 = "sha256-SZ7ZJYuCYU0NxWHlEszbvFmyZxWeBtmPL204PjIrS64=";

  meta = {
    description = "Japanese font, non-free replacement for MS Gothic and MS Mincho";
    longDescription = ''
      Kochi Gothic and Kochi Mincho were developed as free replacements for the
      MS Gothic and MS Mincho fonts from Microsoft. This version of the fonts
      includes some non-free glyphs from the naga10 font, which stipulate that
      this font may not be sold commercially. See kochi-substitute for the free
      Debian version.
    '';
    homepage = "https://osdn.net/projects/efont/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.auntie ];
  };
}
