{ stdenv, fetchurl, libibumad }:

stdenv.mkDerivation rec {
  name = "libibmad-1.3.11";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/${name}.tar.gz";
    sha256 = "1d5lh2lhz7zzs7bbjjv9i0pj3v1xgp8sdmcr425h563v2c3bp53h";
  };

  buildInputs = [ libibumad ];

  meta = with stdenv.lib; {
    homepage = http://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
