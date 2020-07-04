{ bctoolbox
, cmake
, fetchFromGitLab
, sqlite
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bzrtp";
  version = "4.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1yjmsbqmymzl4r7sba6w4a2yld8m6hzafr6jf7sj0syhwpnc3zv6";
  };

  buildInputs = [ bctoolbox sqlite ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  meta = with stdenv.lib; {
    description = "BZRTP is an opensource implementation of ZRTP keys exchange protocol";
    homepage = "https://gitlab.linphone.org/BC/public/bzrtp";
    # They have switched to GPLv3 on git HEAD so probably the next release will
    # be GPL3.
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
