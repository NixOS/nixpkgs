{ stdenv, fetchurl, unzip, cmake }:

stdenv.mkDerivation {
  name = "metis-5.1.0";

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz";
    sha256 = "1cjxgh41r8k6j029yxs8msp3z6lcnpm16g5pvckk35kc7zhfpykn";
  };

  cmakeFlags = [ "-DGKLIB_PATH=../GKlib" ];
  buildInputs = [ unzip cmake ];

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "http://glaros.dtc.umn.edu/gkhome/metis/metis/overview";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
  };
}
