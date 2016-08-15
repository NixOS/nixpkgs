{ stdenv, fetchurl, autoreconfHook, boost, python, libgsf,
  pkgconfig, bzip2, xmlto, gettext, imagemagick, doxygen }:

stdenv.mkDerivation rec {
  name = "libpst-0-6-63";

  src = fetchurl {
      url = http://www.five-ten-sg.com/libpst/packages/libpst-0.6.63.tar.gz;
      sha256 = "0qih919zk40japs4mpiaw5vyr2bvwz60sjf23gixd5vvzc32cljz";
    };

  buildInputs = [ autoreconfHook boost python libgsf pkgconfig bzip2
		  xmlto gettext imagemagick doxygen ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.five-ten-sg.com/libpst/;
    description = "A library to read PST (MS Outlook Personal Folders) files";
    license = licenses.gpl2;
    maintainers = [maintainers.tohl];
    platforms = platforms.unix;
  };
}
