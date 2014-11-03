{ stdenv, fetchurl }:

let version = "20030809";
in
stdenv.mkDerivation {
  name = "kochi-substitute-naga10-${version}";

  src = fetchurl {
    url = "mirror://sourceforgejp/efont/5411/kochi-substitute-${version}.tar.bz2";
    sha256 = "f4d69b24538833bf7e2c4de5e01713b3f1440960a6cc2a5993cb3c68cd23148c";
  };

  sourceRoot = "kochi-substitute-${version}";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp ./kochi-gothic-subst.ttf $out/share/fonts/truetype/kochi-gothic-subst-naga10.ttf
    cp ./kochi-mincho-subst.ttf $out/share/fonts/truetype/kochi-mincho-subst-naga10.ttf
  '';

  meta = {
    description = "Japanese font, non-free replacement for MS Gothic and MS Mincho.";
    longDescription = ''
      Kochi Gothic and Kochi Mincho were developed as free replacements for the
      MS Gothic and MS Mincho fonts from Microsoft. This version of the fonts
      includes some non-free glyphs from the naga10 font, which stipulate that
      this font may not be sold commercially. See kochi-substitute for the free
      Debian version.
    '';
    homepage = http://sourceforge.jp/projects/efont/;
    license = stdenv.lib.licenses.unfreeRedistributable;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
