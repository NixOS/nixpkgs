{ lib, fetchzip }:

let version = "20030809";
in
fetchzip {
  name = "kochi-substitute-naga10-${version}";

  url = "mirror://sourceforgejp/efont/5411/kochi-substitute-${version}.tar.bz2";

  postFetch = ''
    tar -xjf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp ./kochi-gothic-subst.ttf $out/share/fonts/truetype/kochi-gothic-subst-naga10.ttf
    cp ./kochi-mincho-subst.ttf $out/share/fonts/truetype/kochi-mincho-subst-naga10.ttf
  '';

  sha256 = "1bjb5cr3wf3d5y7xj1ly2mkv4ndwvg615rb1ql6lsqc2icjxk7j9";

  meta = {
    description = "Japanese font, non-free replacement for MS Gothic and MS Mincho";
    longDescription = ''
      Kochi Gothic and Kochi Mincho were developed as free replacements for the
      MS Gothic and MS Mincho fonts from Microsoft. This version of the fonts
      includes some non-free glyphs from the naga10 font, which stipulate that
      this font may not be sold commercially. See kochi-substitute for the free
      Debian version.
    '';
    homepage = http://sourceforge.jp/projects/efont/;
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.auntie ];
  };
}
