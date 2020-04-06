{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "vid-stab";
  version = "0.98b";
  
  src = fetchurl {
    url = "https://github.com/georgmartius/vid.stab/archive/release-${version}.tar.gz";
    sha256 = "09fh6xbd1f5xp3il3dpvr87skmnp2mm2hfmg4s9rvj4y8zvhn3sk";
  };

  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "Video stabilization library";
    homepage    = http://public.hronopik.de/vid.stab/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}

