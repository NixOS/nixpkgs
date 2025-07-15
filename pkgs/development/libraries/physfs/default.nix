{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  zlib,
}:

let
  generic =
    version: sha256:
    stdenv.mkDerivation rec {
      pname = "physfs";
      inherit version;

      src = fetchFromGitHub {
        owner = "icculus";
        repo = "physfs";
        rev = "release-${version}";
        inherit sha256;
      };

      patches = [
        (./. + "/dont-set-cmake-skip-rpath-${version}.patch")
      ];

      nativeBuildInputs = [
        cmake
        doxygen
      ];

      buildInputs = [ zlib ];

      doInstallCheck = true;

      installCheckPhase = ''
        ./test_physfs --version
      '';

      meta = with lib; {
        homepage = "https://icculus.org/physfs/";
        description = "Library to provide abstract access to various archives";
        mainProgram = "test_physfs";
        changelog = "https://github.com/icculus/physfs/releases/tag/release-${version}";
        license = licenses.zlib;
        platforms = platforms.all;
      };
    };

in
{
  physfs_2 = generic "2.1.1" "sha256-hmS/bfszit3kD6B2BjnuV50XKueq2GcRaqyAKLkvfLc=";
  physfs = generic "3.2.0" "sha256-FhFIshX7G3uHEzvHGlDIrXa7Ux6ThQNzVssaENs+JMw=";
}
