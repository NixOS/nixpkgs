{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_15,
  callPackage,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zmx";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "neurosnap";
    repo = "zmx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NyYQU8A2ILR/ohtNG8Dv7KDsBOvE7UcjEGnO1Af49eM=";
  };

  nativeBuildInputs = [ zig.hook ];

  deps = callPackage ./build.zig.zon.nix { };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    homepage = "https://github.com/neurosnap/zmx";
    description = "Session persistence for terminal processes";
    longDescription = ''
      zmx provides session persistence for terminal shell sessions (pty processes).
      Features include ability to attach and detach from shell sessions without killing them,
      native terminal scrollback, multiple client connections to the same session,
      and restoration of previous terminal state and output when re-attaching.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GabrielDougherty ];
    mainProgram = "zmx";
    platforms = lib.platforms.unix;
  };
})
