{ lib, stdenv, fetchurl, cmake, hdf5 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "medfile";
  version = "5.0.0";

  src = fetchurl {
    url = "https://files.salome-platform.org/Salome/medfile/med-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Jn520MZ+xRwQ4xmUhOwVCLqo1e2EXGKK32YFKdzno9Q=";
  };

  outputs = [ "out" "doc" "dev" ];

  postPatch = ''
    # Patch cmake and source files to work with hdf5
    substituteInPlace config/cmake_files/medMacros.cmake --replace-fail \
      "IF (NOT HDF_VERSION_MAJOR_REF EQUAL 1 OR NOT HDF_VERSION_MINOR_REF EQUAL 12 OR NOT HDF_VERSION_RELEASE_REF GREATER 0)" \
      "IF (HDF5_VERSION VERSION_LESS 1.12.0)"
    substituteInPlace src/*/*.c --replace-warn \
      "#if H5_VERS_MINOR > 12" \
      "#if H5_VERS_MINOR > 14"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Some medfile test files #define _a, which
    # breaks system header files that use _a as a function parameter
    substituteInPlace tests/c/*.c \
      --replace-warn "_a" "_A" \
      --replace-warn "_b" "_B"
    # Fix compiler errors in test files
    substituteInPlace tests/c/*.c \
      --replace-warn "med_Bool" "med_bool" \
      --replace-warn "med_Axis_type" "med_axis_type" \
      --replace-warn "med_Access_mode" "med_access_mode"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ hdf5 ];

  checkPhase = "make test";

  postInstall = "rm -r $out/bin/testc";

  meta = with lib; {
    description = "Library to read and write MED files";
    homepage = "https://salome-platform.org/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl3Plus;
  };
})
