{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  name = "helvetica-neue-lt-std";
  version = "2014.08.16"; # date of most recent file in distribution

  src = fetchzip {
    url = "https://web.archive.org/web/20190823153624/http://ephifonts.com/downloads/helvetica-neue-lt-std.zip";
    stripRoot = false;
    hash = "sha256-ytoTTrnwN1lMw/gTxS4DRAq+tV5WzB2xHP4vVxLZ1ZI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 'Helvetica Neue LT Std'/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://web.archive.org/web/20190926040940/http://www.ephifonts.com/free-helvetica-font-helvetica-neue-lt-std.html";
    description = "Helvetica Neue LT Std font";
    longDescription = ''
      Helvetica Neue Lt Std is one of the most highly rated and complete
      fonts of all time. Developed in early 1983, this font has well
      camouflaged heights and weights. The structure of the word is uniform
      throughout all the characters.

      The legibility with Helvetica Neue LT Std is said to have improved as
      opposed to other fonts. The tail of it is much longer in this
      font. The numbers are well spaced and defined with high accuracy. The
      punctuation marks are heavily detailed as well.
    '';
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
