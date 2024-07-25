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
  wayland-protocols,
  zig_0_12,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylock";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ifreund";
    repo = "waylock";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-U8xJucLpmeLdmSUc+AVSH/mlv6UOXsxotJPTMK7lnkA=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland
    zig_0_12.hook
  ];

  buildInputs = [
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

  passthru.updateScript = ./update.nu;

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
