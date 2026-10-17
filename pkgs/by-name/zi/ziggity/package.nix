{
  lib,
  bash,
  coreutils,
  stdenv,
  fetchFromGitHub,
  git,
  gnugrep,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  zig_0_16,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggity";
  version = "0.30.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "simoarpe";
    repo = "ziggity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OssZNyfA1dQa578+IebQh5FenmU5TFcfX3ynUjg7sf0=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-pe34plcSfNsvYytU/Gps7cPSUbyd2octV3/Fg9H9qcY=";
  };

  postPatch = ''
    substituteInPlace src/git.zig src/app.zig \
      --replace-fail "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin" \
        "${lib.makeBinPath finalAttrs.nativeCheckInputs}"
  '';

  postConfigure = ''
    cp -rLT ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    makeWrapper
    zig
  ];

  nativeCheckInputs = [
    bash
    coreutils
    git
    gnugrep
  ];

  doCheck = true;

  postInstall = ''
    wrapProgram "$out/bin/ziggity" \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/ziggity";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(.*)$"
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Fast, keyboard-driven terminal UI for Git";
    homepage = "https://github.com/simoarpe/ziggity";
    changelog = "https://github.com/simoarpe/ziggity/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "ziggity";
    platforms = lib.platforms.unix;
  };
})
