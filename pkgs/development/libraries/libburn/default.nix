{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libburn";
<<<<<<< HEAD
  version = "1.5.6";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-cpVJG0vl7qxeej+yBn4jbilV/9xrvUX1RkZu3uMhZEs=";
=======
  version = "1.5.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-UlBZ0QdZxcuBSO68hju1EOMRxmNgPae9LSHEa3z2O1Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    homepage = "http://libburnia-project.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    mainProgram = "cdrskin";
    platforms = with platforms; unix;
  };
}
