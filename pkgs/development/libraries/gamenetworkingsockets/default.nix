{ lib, stdenv, fetchFromGitHub, cmake, ninja, go, protobuf, openssl }:

stdenv.mkDerivation rec {
  pname = "GameNetworkingSockets";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d3k1ciw8c8rznxsr4bfmw0f0srblpflv8xqavhcxx2zwvaya78c";
  };

  nativeBuildInputs = [ cmake ninja go ];

  cmakeFlags = [ "-G Ninja" ];

  # tmp home for go
  preBuild = "export HOME=\"$TMPDIR\"";

  buildInputs = [ protobuf ];
  propagatedBuildInputs = [ openssl ];

  meta = with lib; {
    description = "GameNetworkingSockets is a basic transport layer for games";
    license = licenses.bsd3;
    platforms = platforms.unix;
    inherit (src.meta) homepage;
    maintainers = [ maintainers.sternenseemann ];
  };
}
