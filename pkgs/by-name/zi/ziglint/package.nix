{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  versionCheckHook,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziglint";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "rockorager";
    repo = "ziglint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kLcUIFMDJHuCA0rn3l5a3h/E6TUwNWA5mWRADCDB1cw=";
  };

  postPatch = ''
    substituteInPlace build.zig \
      --replace-fail "getVersion(b)" '"${finalAttrs.version}"'
  '';

  nativeBuildInputs = [ zig.hook ];

  strictDeps = true;

  __structuredAttrs = true;

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/rockorager/ziglint";
    description = "Linter for Zig source code";
    changelog = "https://github.com/rockorager/ziglint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xqtc161 ];
    mainProgram = "ziglint";
    inherit (zig.meta) platforms;
  };
})
