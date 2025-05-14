{
  lib,
  stdenv,
  callPackage,
  fetchFromGitea,
  libxkbcommon,
  pam,
  pkg-config,
  scdoc,
  wayland,
  wayland-scanner,
  wayland-protocols,
  zig_0_14,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylock";
  version = "1.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ifreund";
    repo = "waylock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lshXVqSn50AujTjIJIcbyhe5GeLLMdmF+Vh3/QvZt00=";
  };

  postPatch = ''
    substituteInPlace build.zig --replace-fail "1.4.0-dev" "1.4.0"
  '';

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland-scanner
    zig_0_14.hook
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
