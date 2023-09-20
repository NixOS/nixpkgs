{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libburn";
  version = "1.5.6";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-cpVJG0vl7qxeej+yBn4jbilV/9xrvUX1RkZu3uMhZEs=";
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
