{
  lib,
  stdenv,
  testers,
  wayland,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  expat,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-scanner";
  inherit (wayland) version src;

  outputs = [
    "out"
    "bin"
    "dev"
  ];
  separateDebugInfo = true;

  mesonFlags = [
    (lib.mesonBool "documentation" false)
    (lib.mesonBool "libraries" false)
    (lib.mesonBool "tests" false)
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) wayland-scanner;

  buildInputs = [
    expat
    libxml2
  ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

<<<<<<< HEAD
  meta = {
    inherit (wayland.meta) homepage license maintainers;
    mainProgram = "wayland-scanner";
    description = "C code generator for Wayland protocol XML files";
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    inherit (wayland.meta) homepage license maintainers;
    mainProgram = "wayland-scanner";
    description = "C code generator for Wayland protocol XML files";
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pkgConfigModules = [ "wayland-scanner" ];
  };
})
