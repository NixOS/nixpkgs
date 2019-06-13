{ stdenv, cmake, fetchFromGitHub, bctoolbox, sqlite }:

stdenv.mkDerivation rec {
  baseName = "bzrtp";
  version = "1.0.6";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0438zzxp82bj5fmvqnwlljkgrz9ab5qm5lgpwwgmg1cp78bp2l45";
  };

  buildInputs = [ bctoolbox sqlite ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "BZRTP is an opensource implementation of ZRTP keys exchange protocol";
    homepage = https://github.com/BelledonneCommunications/bzrtp;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
