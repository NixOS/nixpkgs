{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libibumad-1.3.9";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/${name}.tar.gz";
    sha256 = "0j52aiwfgasf7bzx65svd5h2ya7848c5racf191i8irsxa155q74";
  };

  meta = with stdenv.lib; {
    homepage = http://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
