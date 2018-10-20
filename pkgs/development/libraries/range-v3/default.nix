{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "range-v3-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = version;
    sha256 = "1s5gj799aa94nfg3r24whq7ck69g0zypf70w14wx64pgwg0424vf";
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
