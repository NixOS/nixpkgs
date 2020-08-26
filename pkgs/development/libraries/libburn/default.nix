{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libburn";
  version = "1.5.2";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${pname}-${version}.tar.gz";
    sha256 = "09sjrvq8xsj1gnl2wwyv4lbmicyzzl6x1ac2rrn53xnp34bxnckv";
  };

  meta = with stdenv.lib; {
    homepage = "http://libburnia-project.org/";
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
