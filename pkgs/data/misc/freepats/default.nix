{ lib, stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  pname = "freepats";
  version = "20221026";

  src = fetchurl {
    url = "https://freepats.zenvoid.org/SoundSets/FreePats-GeneralMIDI/FreePatsGM-SF2-${version}.7z";
    hash = "sha256-wvXHd4UeOthsuhGb+RqmuRUCJRLoHDfqAQ7mo/i1QV0=";
  };

  nativeBuildInputs = [ p7zip ];

  installPhase = ''mkdir "$out"; cp -r . "$out"'';

  meta = with lib; {
    description = "Instrument patches, for MIDI synthesizers";
    longDescription = ''
      Freepats is a project to create a free and open set of instrument
      patches, in any format, that can be used with softsynths.
    '';
    homepage = "https://freepats.zenvoid.org/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
