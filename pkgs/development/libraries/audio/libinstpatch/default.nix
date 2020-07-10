{ stdenv, fetchFromGitHub, cmake, pkg-config, glib, libsndfile }:

stdenv.mkDerivation rec {
  pname = "libinstpatch";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "swami";
    repo = pname;
    rev = "v${version}";
    sha256 = "0psx4hc5yksfd3k2xqsc7c8lbz2d4yybikyddyd9hlkhq979cmjb";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ glib libsndfile ]; # Both are needed for includes.

  cmakeFlags = [
    "-DLIB_SUFFIX=" # Install in $out/lib.
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.swamiproject.org/";
    description = "MIDI instrument patch files support library";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
