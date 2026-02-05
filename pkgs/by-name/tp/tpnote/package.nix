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
  version = "1.25.17";

  src = fetchFromGitHub {
    owner = "getreu";
    repo = "tp-note";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XOoqPhWS50kj2n48A0SyOuUZHsoP7YxMrWpzgpTr/DY=";
  };

  cargoHash = "sha256-4e06W8Q+pJTcUgfDSHU1ZTMG/55mYvJ6DAX3QeAa9TI=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
  ];

  postPatch = ''
    # In these `Cargo.toml`s, local dependencies should be specified by path,
    # otherwise they will be looked up in vendored dependencies.
    substituteInPlace tpnote/Cargo.toml \
      --replace-fail 'tpnote-lib = { version =' 'tpnote-lib = { path = "../tpnote-lib", version ='

    substituteInPlace tpnote-lib/Cargo.toml \
      --replace-fail 'tpnote-html2md = { version =' 'tpnote-html2md = { path = "../tpnote-html2md", version ='
  '';

  postInstall = ''
    installManPage docs/build/man/man1/tpnote.1
  '';

  env.RUSTONIG_SYSTEM_LIBONIG = true;

  # The `tpnote` crate has no unit tests. All tests are in `tpnote-lib`.
  checkType = "debug";
  cargoTestFlags = [
    "--package"
    "tpnote-lib"
  ];
  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
    maintainers = with lib.maintainers; [
      getreu
      starryreverie
    ];
  };
})
