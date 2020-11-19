{ stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  version = "1.3.6";
  pname = "draco";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = version;
    sha256 = "06adhz8gsnns6q98yzjm64xs04qp2fhm9bv0wxny68rkw0bh95a0";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Fake these since we are building from a tarball
    "-Ddraco_git_hash=${version}"
    "-Ddraco_git_desc=${version}"

    "-DBUILD_UNITY_PLUGIN=1"
  ];

  meta = with stdenv.lib; {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
}
