{ stdenv, fetchurl, cmake, doxygen
, zlib }:

let
  generic = version: sha256:
  stdenv.mkDerivation rec {
    name = "physfs-${version}";

    src = fetchurl {
      url = "${meta.homepage}/downloads/${name}.tar.bz2";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake doxygen ];

    buildInputs = [ zlib ];

    enableParallelBuilding = true;

    patchPhase = ''
      sed s,-Werror,, -i CMakeLists.txt
    '';

    doInstallCheck = true;

    installCheckPhase = ''
      ./test_physfs --version
    '';

    meta = with stdenv.lib; {
      homepage = http://icculus.org/physfs/;
      description = "Library to provide abstract access to various archives";
      license = licenses.free;
      platforms = platforms.linux;
    };
  };

in {
  physfs_2 = generic "2.0.3" "0sbbyqzqhyf0g68fcvvv20n3928j0x6ik1njmhn1yigvq2bj11na";
  physfs   = generic "3.0.1" "1wgj2zqpnfbnyyi1i7bq5pshcc9n5cvwlpzp8im67nb8662ryyxp";
}
