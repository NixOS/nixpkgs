{
  lib,
  stdenv,
  fetchurl,
  cmake,
  hdf5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "medfile";
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
  };

  outputs = [
    "out"
    "doc"
    "dev"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  meta = {
    description = "Library to read and write MED files";
    homepage = "https://salome-platform.org/";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.lgpl3Plus;
  };
})
