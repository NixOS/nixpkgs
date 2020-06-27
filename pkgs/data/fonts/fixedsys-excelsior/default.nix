{ lib, mkFont, fetchurl } :

mkFont rec {
  pname = "fixedsys-excelsior";
  version = "3.00";

  src = fetchurl {
    urls = [
      "http://www.fixedsysexcelsior.com/fonts/FSEX300.ttf"
      "https://raw.githubusercontent.com/chrissimpkins/codeface/master/fonts/fixed-sys-excelsior/FSEX300.ttf"
      "http://tarballs.nixos.org/sha256/6ee0f3573bc5e33e93b616ef6282f49bc0e227a31aa753ac76ed2e3f3d02056d"
    ];
    sha256 = "0v8508ykybpdfsn579qslcky5h4vyj165vqnns9kxqy57dbz7q3f";
  };

  noUnpackFonts = true;

  meta = with lib; {
    description = "Pan-unicode version of Fixedsys, a classic DOS font.";
    homepage = "http://www.fixedsysexcelsior.com/";
    platforms = platforms.all;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ninjatrappeur ];
  };
}
