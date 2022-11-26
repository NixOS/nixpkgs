{ stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation rec {
  pname = "apriltag";
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "AprilRobotics";
    repo = pname;
    rev = "v${version}";
    sha256 = "pJFTzWX8zLzcDfPCg8v44fwlxEMVeRylcggFk7B5m7g=";
  };
  nativeBuildInputs = [
    cmake
    ninja
  ];
  postInstall = ''
    mv $out/share/*/cmake/* $out/share/*/
    rmdir $out/share/*/cmake
    mkdir -p $out/lib/cmake
    mv $out/share/* $out/lib/cmake
    rm -rf $out/share
  '';
}
