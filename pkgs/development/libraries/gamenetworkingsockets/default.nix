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
    repo = pname;
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

  meta = with lib; {
    description = "GameNetworkingSockets is a basic transport layer for games";
    license = licenses.bsd3;
    platforms = platforms.unix;
    inherit (src.meta) homepage;
    maintainers = [ maintainers.sternenseemann ];
  };
}
