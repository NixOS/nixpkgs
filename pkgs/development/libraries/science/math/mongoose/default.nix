{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "mongoose";
  version = "2.0.4";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ScottKolo";
    repo = "Mongoose";
    rev = "v${version}";
    sha256 = "0ymwd4n8p8s0ndh1vcbmjcsm0x2cc2b7v3baww5y6as12873bcrh";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with stdenv.lib; {
    description = "Graph Coarsening and Partitioning Library";
    homepage = "https://github.com/ScottKolo/Mongoose";
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = with platforms; unix;
  };
}
