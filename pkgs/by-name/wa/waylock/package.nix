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
  zig_0_13,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylock";
  version = "1.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ifreund";
    repo = "waylock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jfMSar+Y3inu1Cly6rIDw+akBJIQ6huL0smAstgQmEo=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland-scanner
    zig_0_13.hook
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
