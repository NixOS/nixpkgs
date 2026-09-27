{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zigdoc";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "rockorager";
    repo = "zigdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OC84SxB0N+QbyXGAfdHDSWde16IwdCkIPbU699wnvY0=";
  };

  nativeBuildInputs = [ zig.hook ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/rockorager/zigdoc";
    description = "CLI tool to view documentation for zig library symbols";
    changelog = "https://github.com/rockorager/zigdoc/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ddogfoodd ];
    mainProgram = "zigdoc";
    inherit (zig.meta) platforms;
  };
})
