{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "usrsctp";
  version = "unstable-2023-05-24";

  src = fetchFromGitHub {
    owner = "sctplab";
    repo = "usrsctp";
    rev = "ac559d2a95277e5e0827e9ee5a1d3b1b50e0822a";
    hash = "sha256-CIdLGBVCVjz3LFAZXc0IcYsQUOG2NpgEHsWNpzs97gI=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/sctplab/usrsctp/issues/662
  postPatch = ''
    substituteInPlace usrsctplib/CMakeLists.txt \
      --replace '$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    homepage = "https://github.com/sctplab/usrsctp";
    description = "A portable SCTP userland stack";
    maintainers = with maintainers; [ misuzu ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
