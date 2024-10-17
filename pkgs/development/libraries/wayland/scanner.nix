{
  lib,
  stdenv,
  wayland,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  expat,
  libxml2,
}:

stdenv.mkDerivation {
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
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) wayland-scanner;

  buildInputs = [
    expat
    libxml2
  ];

  meta = with lib; {
    inherit (wayland.meta) homepage license maintainers;
    mainProgram = "wayland-scanner";
    description = "C code generator for Wayland protocol XML files";
    platforms = platforms.unix;
  };
}
