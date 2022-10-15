{ lib, fetchurl } :

let
  version = "3.00";
in fetchurl rec {
  name = "fixedsys-excelsior-${version}";

  url = "https://raw.githubusercontent.com/chrissimpkins/codeface/master/fonts/fixed-sys-excelsior/FSEX300.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -m444 -D $downloadedFile $out/share/fonts/truetype/${name}.ttf
  '';

  sha256 = "32d6f07f1ff08c764357f8478892b2ba5ade23427af99759f34a0ba24bcd2e37";

  meta = {
    homepage = "http://www.fixedsysexcelsior.com/";
    description = "Pan-unicode version of Fixedsys, a classic DOS font";
    platforms = lib.platforms.all;
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.ninjatrappeur ];
  };
}
