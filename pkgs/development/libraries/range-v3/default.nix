{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "range-v3-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = version;
    sha256 = "0fzbpaa4vwlivi417zxm1d6v4lkp5c9f5bd706nn2fmw3zxjj815";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  checkTarget = "test";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Experimental range library for C++11/14/17";
    homepage = https://github.com/ericniebler/range-v3;
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
