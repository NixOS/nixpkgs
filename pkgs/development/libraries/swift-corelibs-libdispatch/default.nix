{ lib
, clangStdenv
, fetchFromGitHub
, cmake
, ninja
, libbsd
, libsystemtap
}:

let
  version = "5.5";
in clangStdenv.mkDerivation {
  pname = "swift-corelibs-libdispatch";
  inherit version;

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-corelibs-libdispatch";
    rev = "swift-${version}-RELEASE";
    sha256 = "sha256-MbLgmS6qRSRT+2dGqbYTNb5MTM4Wz/grDXFk1kup+jk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libbsd
    libsystemtap
  ];

  meta = {
    description = "Grand Central Dispatch";
    homepage = "https://github.com/apple/swift-corelibs-libdispatch";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.cmm ];
  };
}
