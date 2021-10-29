{ lib, stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  version = "1.4.3";
  pname = "draco";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = version;
    sha256 = "sha256-eSu6tkWbRHzJkWwPgljaScAuL0gRkp8PJUHWC8mUvOw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Fake these since we are building from a tarball
    "-Ddraco_git_hash=${version}"
    "-Ddraco_git_desc=${version}"

    "-DBUILD_UNITY_PLUGIN=1"
  ];

  meta = with lib; {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
}
