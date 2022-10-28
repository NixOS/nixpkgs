{ lib, stdenv, fetchFromGitHub, cmake, doxygen, zlib, Foundation }:

let
  generic = version: sha256:
  stdenv.mkDerivation rec {
    pname = "physfs";
    inherit version;

    src = fetchFromGitHub {
      owner = "icculus";
      repo = "physfs";
      rev = "release-${version}";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake doxygen ];

    buildInputs = [ zlib ]
      ++ lib.optionals stdenv.isDarwin [ Foundation ];

    doInstallCheck = true;

    installCheckPhase = ''
      ./test_physfs --version
    '';

    meta = with lib; {
      homepage = "http://icculus.org/physfs/";
      description = "Library to provide abstract access to various archives";
      license = licenses.free;
      platforms = platforms.unix;
    };
  };

in {
  physfs_2 = generic "2.1.1" "sha256-hmS/bfszit3kD6B2BjnuV50XKueq2GcRaqyAKLkvfLc=";
  physfs   = generic "3.0.2" "0qzqz4r88gvd8m7sh2z5hvqcr0jfr4wb2f77c19xycyn0rigfk9h";
}
