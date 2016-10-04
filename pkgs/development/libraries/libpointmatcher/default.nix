{stdenv, fetchFromGitHub, cmake, eigen, boost, libnabo}:

stdenv.mkDerivation rec {
  version = "2016-09-11";
  name = "libpointmatcher-${version}";

  src = fetchFromGitHub {
    owner = "ethz-asl";
    repo = "libpointmatcher";
    rev = "75044815d40ff934fe0bb7e05ed8bbf18c06493b";
    sha256 = "1s7ilvg3lhr1fq8sxw05ydmbd3kl46496jnyxprhnpgvpmvqsbzl";
  };

  buildInputs = [cmake eigen boost libnabo];

  enableParallelBuilding = true;

  cmakeFlags = "
    -DEIGEN_INCLUDE_DIR=${eigen}/include/eigen3
  ";

  checkPhase = ''
  export LD_LIBRARY_PATH=$PWD
  ./utest/utest --path ../examples/data/
  '';
  doCheck = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "An \"Iterative Closest Point\" library for 2-D/3-D mapping in robotic";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cryptix ];
  };
}
