{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libzra";
  version = "unstable-2020-09-11";

  src = fetchFromGitHub {
    owner = "zraorg";
    repo = "zra";
    rev = "57abf2774dfc4624f14a0bc5bba71f044ce54a38";
    sha256 = "10rlqj6ma02005gdcp57wp48d6cg0vkbv4vl9ai0zlgxyx1g6kc4";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/zraorg/ZRA";
    description = "Library for ZStandard random access";
    platforms = platforms.all;
    maintainers = [ maintainers.ivar ];
    license = licenses.bsd3;
  };
}
