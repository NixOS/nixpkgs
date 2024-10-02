{
  callPackage,
  lib,
  zig_0_13,
  stdenv,
  fetchFromSourcehut,
  fcft,
  libxkbcommon,
  pixman,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayprompt";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wayprompt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+9Zgq5/Zbb1I3CMH1pivPkddThaGDXM+vVCzWppXq+0=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_13.hook
    pkg-config
    wayland
    wayland-scanner
    scdoc
  ];

  buildInputs = [
    fcft
    libxkbcommon
    pixman
    wayland-protocols
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    homepage = "https://git.sr.ht/~leon_plickat/wayprompt";
    description = "Multi-purpose (password-)prompt tool for Wayland";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sg-qwt ];
    mainProgram = "pinentry-wayprompt";
    platforms = lib.platforms.linux;
  };
})
