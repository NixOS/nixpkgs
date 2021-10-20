{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, glib, libsndfile }:

stdenv.mkDerivation rec {
  pname = "libinstpatch";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "swami";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OU6/slrPDgzn9tvXZJKSWbcFbpS/EAsOi52FtjeYdvA=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ glib libsndfile ]; # Both are needed for includes.

  cmakeFlags = [
    "-DLIB_SUFFIX=" # Install in $out/lib.
  ];

  meta = with lib; {
    homepage = "http://www.swamiproject.org/";
    description = "MIDI instrument patch files support library";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
