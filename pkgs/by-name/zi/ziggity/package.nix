{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  gitMinimal,
  bash,
  coreutils,
  gnugrep,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggity";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "simoarpe";
    repo = "ziggity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QAW2cXr2pBLDD08rPye2ALWk0VvXoped3c0OtDb02W4=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-OjvuVDDu5l6pxx0Yew0TxqZQ6OsnPeU7x3ZMfnvhdLU=";
  };

  # Tests run git with a hardcoded macOS-style PATH
  postPatch = ''
    substituteInPlace src/app.zig src/git.zig \
      --replace-fail "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin" \
        "${
          lib.makeBinPath [
            gitMinimal
            bash
            coreutils
            gnugrep
          ]
        }"
  '';

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    zig.hook
    makeBinaryWrapper
  ];

  strictDeps = true;

  __structuredAttrs = true;

  doCheck = true;
  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    export HOME=$TMPDIR
    git config --global user.name nixbld
    git config --global user.email nixbld@localhost
  '';

  postInstall = ''
    wrapProgram $out/bin/ziggity \
      --suffix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, keyboard-driven terminal UI for Git";
    homepage = "https://ziggity.dev";
    changelog = "https://github.com/simoarpe/ziggity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abuibrahim ];
    mainProgram = "ziggity";
    inherit (zig.meta) platforms;
  };
})
