{
  stdenv,
  cmake,
  fetchFromGitHub,
}: let
  pname = "namedtype";
  version = "unstable-77a95c8";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "joboccara";
      repo = pname;
      rev = "77a95c8002a28f5cb48d2d0cd985904d66912af3";
      hash = "sha256-QIbDJ586X9431V+HgPx/gf3FClOrk4hWAY0C7kBe/6I=";
    };

    cmakeFlags = ["-DENABLE_TEST=OFF"];

    nativeBuildInputs = [cmake];
  }
