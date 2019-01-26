{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libibumad-1.3.10.2";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/${name}.tar.gz";
    sha256 = "0bkygb3lbpaj6s4vsyixybrrkcnilbijv4ga5p1xdwyr3gip83sh";
  };

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
