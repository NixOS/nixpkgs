{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libburn";
  version = "1.5.2.pl01";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1xrp9c2sppbds0agqzmdym7rvdwpjrq6v6q2c3718cwvbjmh66c8";
  };

  meta = with lib; {
    homepage = "http://libburnia-project.org/";
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
