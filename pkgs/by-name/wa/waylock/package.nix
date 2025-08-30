{
  lib,
  stdenv,
  fetchFromGitea,
  libxkbcommon,
  pam,
  pkg-config,
  scdoc,
  wayland,
  wayland-scanner,
  wayland-protocols,
  zig_0_14,
  nix-update-script,
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

  zigDeps = zig_0_14.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QU+YW38wIFKiQtKolgYgzXbXW4aKvJTHDBIqgitVutg=";
  };

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
  ];

  preBuild = ''
    substituteInPlace pam.d/waylock --replace-fail "system-auth" "login"
  '';

  passthru.updateScript = nix-update-script { };

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
