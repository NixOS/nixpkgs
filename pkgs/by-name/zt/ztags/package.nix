{
  lib,
  stdenv,
  fetchFromGitHub,
  scdoc,
  zig_0_13,
  apple-sdk_11,
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

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  postInstall = ''
    zig build docs --prefix $out
  '';

  meta = {
    description = "Generate tags files for Zig projects";
    homepage = "https://github.com/gpanders/ztags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "ztags";
    inherit (zig.meta) platforms;
  };
})
