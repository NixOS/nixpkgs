{ lib, stdenv, fetchFromGitHub, cmake, ninja, go, protobuf, openssl }:

stdenv.mkDerivation rec {
  pname = "GameNetworkingSockets";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DB3l1eZf9M7gVrijTd2lK2vgAK9ukay7/RkxxCMLc7Q=";
  };

  nativeBuildInputs = [ cmake ninja go ];

  cmakeFlags = [ "-G Ninja" ];

  # tmp home for go
  preBuild = "export HOME=\"$TMPDIR\"";

  buildInputs = [ protobuf openssl ];

  meta = with lib; {
    # build failure is resolved on master, remove at next release
    broken = stdenv.isDarwin;
    description = "GameNetworkingSockets is a basic transport layer for games";
    license = licenses.bsd3;
    platforms = platforms.unix;
    inherit (src.meta) homepage;
    maintainers = [ maintainers.sternenseemann ];
  };
}
