{  stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.6.1";
  name = "arrayfire-${version}";
  src = fetchurl {
    url = "http://arrayfire.s3.amazonaws.com/3.6.1/ArrayFire-v3.6.1_Linux_x86_64.sh";
    sha256 = "14qsdbq2yz5bmj5zg4y8sb9pybz2h41zsc3fqv9nhmfmllb004gc";
  };

  phases = "installPhase";

  installPhase = ''
    bash ${src} --include-subdirs --prefix=$out
    cd $out && mv arrayfire/* .
    rm -rf arrayfire
  '';

  meta = with stdenv.lib; {
    description = "Multiplatform library for parallel GPU computation";
    homepage = http://www.arrayfire.com/;
    maintainers = with maintainers; [ "jmagoon" ];
    license = licenses.cc-by-40;
    platforms = platforms.linux;
  };
}
