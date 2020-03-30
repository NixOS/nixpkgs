{ stdenv, fetchFromGitHub, cmake, pkg-config, glib, libsndfile }:

stdenv.mkDerivation rec {
  pname = "libinstpatch";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "swami";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ksilyszcm7mwb6m8qyrgalvh4h2vkyz7wzj0xczcqkj15bcl4lw";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ glib libsndfile ]; # Both are needed for includes.

  cmakeFlags = [
    "-DLIB_SUFFIX=" # Install in $out/lib.
  ];

  meta = with stdenv.lib; {
    homepage = http://www.swamiproject.org/;
    description = "MIDI instrument patch files support library";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
