{
  lib,
  stdenv,
  callPackage,
  fetchFromCodeberg,
  libxkbcommon,
  pam,
  pkg-config,
  scdoc,
  wayland,
  wayland-scanner,
  wayland-protocols,
  zig_0_16,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "waylock";
  version = "1.6.0";

  src = fetchFromCodeberg {
    owner = "ifreund";
    repo = "waylock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A/XPgoon1J+fmEVUGuqvqbimRRDfLPkzkMYipPaKrfo=";
  };

  postPatch = ''
    substituteInPlace build.zig --replace-fail "1.4.0-dev" "${finalAttrs.version}"
  '';

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland-scanner
    zig
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    pam
  ];

  zigBuildFlags = [
    "-Dman-pages"
    "--system"
    "${finalAttrs.deps}"
  ];

  preBuild = ''
    substituteInPlace pam.d/waylock --replace-fail "system-auth" "login"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://codeberg.org/ifreund/waylock";
    changelog = "https://codeberg.org/ifreund/waylock/releases/tag/v${finalAttrs.version}";
    description = "Small screenlocker for Wayland compositors";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      adamcstephens
      jordanisaacs
    ];
    mainProgram = "waylock";
    platforms = lib.platforms.linux;
  };
})
