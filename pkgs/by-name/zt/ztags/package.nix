{
  lib,
  stdenv,
  fetchFromGitHub,
  scdoc,
  zig_0_13,
}:

let
  zig = zig_0_13;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ztags";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "gpanders";
    repo = "ztags";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XDwHuQ+UwScolxyxCHJUmxxG+OgKvZmNGQEZlfywV2s=";
  };

  nativeBuildInputs = [
    scdoc
    zig.hook
  ];

  postInstall = ''
    zig build docs --prefix $out
  '';

  meta = {
    description = "Generate tags files for Zig projects";
    homepage = "https://github.com/gpanders/ztags";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ztags";
    inherit (zig.meta) platforms;
  };
})
