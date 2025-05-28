{
  lib,
  callPackage,
  fcft,
  fetchFromSourcehut,
  fontconfig,
  freetype,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig,
  versionCheckHook,
}:
stdenv.mkDerivation (final: {
  pname = "zelbar";
  version = "1.2.0";

  src = fetchFromSourcehut {
    # TODO; use when upstream updated to zig 0.14
    # owner = "~novakane";
    owner = "~wlcx";
    repo = "zelbar";
    #rev = "v${final.version}";
    rev = "main";
    hash = "sha256-6/ETbE25BcAG5WK/AsMS1PkgwLk0Meo10k7WEFQxDEY=";
  };

  postPatch = ''
    ln -s ${callPackage ./build.zig.zon.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig.hook
    pkg-config
    fcft
    fontconfig
    freetype
    pixman
    wayland
    wayland-protocols
    wayland-scanner
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  meta = {
    description = "Wayland statusbar reading input from STDIN, inspired by lemonbar.";
    homepage = "https://git.sr.ht/~novakane/zelbar/";
    maintainers = [ lib.maintainers.samw ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "zelbar";
  };
})
