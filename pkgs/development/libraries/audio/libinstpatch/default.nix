{ stdenv, fetchFromGitHub, cmake, pkg-config, glib, libsndfile }:

stdenv.mkDerivation rec {
  pname = "libinstpatch";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "swami";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v7mv43xxwrzi3agrc60agcw46jaidr8ql9kkm1w4jxkf4c6z6dz";
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
