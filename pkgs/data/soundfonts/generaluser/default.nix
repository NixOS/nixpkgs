{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "generaluser";
  version = "1.471";

  # we can't use fetchurl since stdenv does not handle unpacking *.zip's by default.
  src = fetchzip {
    # Linked on https://www.schristiancollins.com/generaluser.php:
    url = "https://www.dropbox.com/s/4x27l49kxcwamp5/GeneralUser_GS_${version}.zip";
    sha256 = "sha256-lwUlWubXiVZ8fijKuNF54YQjT0uigjNAbjKaNjmC51s=";
  };

  installPhase = ''
    install -Dm644 GeneralUser*.sf2 $out/share/soundfonts/GeneralUser-GS.sf2
  '';

  meta = with lib; {
    description = "a SoundFont bank featuring 259 instrument presets and 11 drum kits";
    homepage = "https://www.schristiancollins.com/generaluser.php";
    license = licenses.generaluser;
    platforms = platforms.all;
    maintainers = with maintainers; [ ckie ];
  };
}
