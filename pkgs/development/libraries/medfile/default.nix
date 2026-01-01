{
  lib,
  stdenv,
  fetchurl,
  cmake,
  hdf5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "medfile";
<<<<<<< HEAD
  version = "6.0.1";

  src = fetchurl {
    url = "https://files.salome-platform.org/Salome/medfile/med-${finalAttrs.version}.tar.gz";
    hash = "sha256-+PHtxodLxI2PPk6L4c9zee0xhybYq8aAToXoIVVbH6g=";

    # salome uses tiger-protect-waf (https://faq.o2switch.fr/cpanel/o2switch/tiger-protect-waf/),
    # which blocks Nixpkgs's custom UA, 403 otherwise
    # OpenSUSE does the same: https://github.com/bmwiedemann/openSUSE/blob/08303e6e850f0de37bfabbd184dae73009f3038b/packages/m/med-tools/med-tools.spec#L32
    curlOptsList = [
      "--user-agent"
      "MozillaFirefox (really Nixpkgs, see https://github.com/NixOS/nixpkgs/pull/474599)"
    ];
=======
  version = "5.0.0";

  src = fetchurl {
    url = "https://files.salome-platform.org/Salome/medfile/med-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Jn520MZ+xRwQ4xmUhOwVCLqo1e2EXGKK32YFKdzno9Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "doc"
    "dev"
  ];

<<<<<<< HEAD
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
=======
  postPatch = ''
    # Patch cmake and source files to work with hdf5
    substituteInPlace config/cmake_files/medMacros.cmake --replace-fail \
      "IF (NOT HDF_VERSION_MAJOR_REF EQUAL 1 OR NOT HDF_VERSION_MINOR_REF EQUAL 12 OR NOT HDF_VERSION_RELEASE_REF GREATER 0)" \
      "IF (HDF5_VERSION VERSION_LESS 1.12.0)"
    substituteInPlace src/*/*.c --replace-warn \
      "#if H5_VERS_MINOR > 12" \
      "#if H5_VERS_MINOR > 14"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Library to read and write MED files";
    homepage = "https://salome-platform.org/";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.lgpl3Plus;
=======
  meta = with lib; {
    description = "Library to read and write MED files";
    homepage = "https://salome-platform.org/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
