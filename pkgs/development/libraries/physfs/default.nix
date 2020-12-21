{ stdenv, fetchurl, cmake, doxygen, darwin
, zlib }:

let
  generic = version: sha256:
  stdenv.mkDerivation rec {
    pname = "physfs";
    inherit version;

    src = fetchurl {
      url = "${meta.homepage}/downloads/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake doxygen ];

    buildInputs = [ zlib ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Foundation ];

    enableParallelBuilding = true;

    patchPhase = ''
      sed s,-Werror,, -i CMakeLists.txt
    '';

    doInstallCheck = true;

    installCheckPhase = ''
      ./test_physfs --version
    '';

    meta = with stdenv.lib; {
      homepage = "http://icculus.org/physfs/";
      description = "Library to provide abstract access to various archives";
      license = licenses.free;
      platforms = platforms.unix;
    };
  };

in {
  physfs_2 = generic "2.0.3" "0sbbyqzqhyf0g68fcvvv20n3928j0x6ik1njmhn1yigvq2bj11na";
  physfs   = generic "3.0.2" "0qzqz4r88gvd8m7sh2z5hvqcr0jfr4wb2f77c19xycyn0rigfk9h";
}
