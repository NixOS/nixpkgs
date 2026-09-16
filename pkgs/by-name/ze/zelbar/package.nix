{
  lib,
  stdenv,
  callPackage,
  fetchFromSourcehut,
  versionCheckHook,

  fcft,
  pixman,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_15,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zelbar";
  version = "1.2.0";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = "zelbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r5kJ7FOSAluytSsQztV8CRHQ63flpFeBOpVZY6CAVbM=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    zig_0_15.hook
  ];

  buildInputs = [
    fcft
    pixman
    wayland
    wayland-protocols
  ];

  postPatch = ''
    ln -s ${finalAttrs.deps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Statusbar for wayland reading from stdin";
    homepage = "https://git.sr.ht/~novakane/zelbar";
    changelog = "https://git.sr.ht/~novakane/zelbar/refs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    mainProgram = "zelbar";
    platforms = lib.platforms.linux;
  };
})
