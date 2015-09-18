{ stdenv, fetchurl, libibumad }:

stdenv.mkDerivation rec {
  name = "libibmad-1.3.12";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/${name}.tar.gz";
    sha256 = "0ywkz0rskci414r6h6jd4iz4qjbj37ga2k91z1mlj9xrnl9bbgzi";
  };

  buildInputs = [ libibumad ];

  meta = with stdenv.lib; {
    homepage = http://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
