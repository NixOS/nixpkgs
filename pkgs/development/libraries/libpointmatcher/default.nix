{ lib, stdenv, fetchFromGitHub, cmake, eigen, boost, libnabo }:

stdenv.mkDerivation rec {
  pname = "libpointmatcher";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ethz-asl";
    repo = pname;
    rev = version;
    sha256 = "0lai6sr3a9dj1j4pgjjyp7mx10wixy5wpvbka8nsc2danj6xhdyd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen boost libnabo ];

  cmakeFlags = [
    "-DEIGEN_INCLUDE_DIR=${eigen}/include/eigen3"
  ];

  doCheck = true;
  checkPhase = ''
    ./utest/utest --path ../examples/data/
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "An \"Iterative Closest Point\" library for 2-D/3-D mapping in robotic";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cryptix ];
  };
}
