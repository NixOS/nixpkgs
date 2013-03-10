{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "physfs-2.0.3";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.bz2";
    sha256 = "0sbbyqzqhyf0g68fcvvv20n3928j0x6ik1njmhn1yigvq2bj11na";
  };

  nativeBuildInputs = [ cmake ];

  patchPhase = ''
    sed s,-Werror,, -i CMakeLists.txt
  '';

  meta = {
    homepage = "http://icculus.org/physfs/";
    description = "Library to provide abstract access to various archives";
    license = "free";
  };
}
