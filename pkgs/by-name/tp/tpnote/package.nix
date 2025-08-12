{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  oniguruma,
  installShellFiles,
  tpnote,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tpnote";
  version = "1.25.14";

  src = fetchFromGitHub {
    owner = "getreu";
    repo = "tp-note";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CgC4aLg1GdqDXzuWfV4i5C4//I3GJ2RJa0y3oFOM0II=";
  };

  cargoHash = "sha256-LF17FrWiqfFaVFbOjm9GiW9AsZmleZL++i8YDyrVZVM=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
  ];

  postInstall = ''
    installManPage docs/build/man/man1/tpnote.1
  '';

  RUSTONIG_SYSTEM_LIBONIG = true;

  # The `tpnote` crate has no unit tests. All tests are in `tpnote-lib`.
  checkType = "debug";
  cargoTestFlags = "--package tpnote-lib";
  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/getreu/tp-note/releases/tag/v${finalAttrs.version}";
    description = "Markup enhanced granular note-taking";
    homepage = "https://blog.getreu.net/projects/tp-note/";
    license = lib.licenses.mit;
    mainProgram = "tpnote";
    maintainers = with lib.maintainers; [ getreu ];
  };
})
