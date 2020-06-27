{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "kochi-substitute-naga10";
  version = "20030809";

  src = fetchzip {
    url = "mirror://osdn/efont/5411/kochi-substitute-${version}.tar.bz2";
    sha256 = "191b7lyvx3j12gv82m4jp04sb24vprl4ymk4czr3r8asl4di417s";
  };

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
