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

      # https://github.com/icculus/physfs/commit/f7d24ce8486d9229207cca1ff98858fe60ffe583
      # but the patch wouldn't apply to physfs_2, so let's do a fuzzy sed.
      postPatch = ''
        sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' \
          -i CMakeLists.txt
      '';

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
