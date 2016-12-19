{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "helvetica-neue-lt-std-${version}";
  version = "2013.06.07"; # date of most recent file in distribution

  src = fetchurl {
    url = "http://www.ephifonts.com/downloads/helvetica-neue-lt-std.zip";
    sha256 = "0nrjdj2a11dr6d3aihvjxzrkdi0wq6f2bvaiimi5iwmpyz80n0h6";
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = "Helvetica Neue LT Std";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v *.otf $out/share/fonts/opentype
  '';

  meta = {
    homepage = http://www.ephifonts.com/free-helvetica-font-helvetica-neue-lt-std.html;
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
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.all;
  };
}
