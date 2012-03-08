{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "physfs-2.0.2";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "02dwy0vsn2dp31f15vxd3yxxr1rgy25ab7ncavyh73i290qnsadf";
  };

  buildNativeInputs = [ cmake ];

  patchPhase = ''
    sed s,-Werror,, -i CMakeLists.txt
  '';

  meta = {
    homepage = http://icculus.org/physfs/;
    description = "Library to provide abstract access to various archives";
    license = "free";
  };
}
