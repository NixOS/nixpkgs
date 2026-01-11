{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  go,
  protobuf,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "GameNetworkingSockets";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "GameNetworkingSockets";
    rev = "v${version}";
    sha256 = "12741wmpvy7mcvqqmjg4a7ph75rwliwgclhk4imjijqf2qkvsphd";
  };

  nativeBuildInputs = [
    cmake
    ninja
    go
  ];

  cmakeFlags = [ "-G Ninja" ];

  # tmp home for go
  preBuild = "export HOME=\"$TMPDIR\"";

  buildInputs = [ protobuf ];
  propagatedBuildInputs = [ openssl ];

  meta = {
    description = "GameNetworkingSockets is a basic transport layer for games";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
