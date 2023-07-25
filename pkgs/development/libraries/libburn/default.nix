{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libburn";
  version = "1.5.4";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-UlBZ0QdZxcuBSO68hju1EOMRxmNgPae9LSHEa3z2O1Q=";
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
