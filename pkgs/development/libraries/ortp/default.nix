{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ortp-0.24.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "05k6ianphr533qnjwxsv7jnh7fb2sq0dj1pdy1bk2w5khmlwfdyb";
  };

  meta = with stdenv.lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
