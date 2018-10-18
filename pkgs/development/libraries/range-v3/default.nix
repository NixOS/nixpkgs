{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "range-v3-${version}";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = version;
    sha256 = "1zhsz1i4jy97idydg7ay3wazp7v2353vckkli5w9g51jka43h5x2";
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
