{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  git,
  bash,
  coreutils,
  gnugrep,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggity";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "simoarpe";
    repo = "ziggity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9AL4M3aUSXgBzMs/hkWAn5k5FuqIUetdWNw9C7XNXcg=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-pe34plcSfNsvYytU/Gps7cPSUbyd2octV3/Fg9H9qcY=";
  };

  # Tests run git with a hardcoded macOS-style PATH
  postPatch = ''
    substituteInPlace src/app.zig src/git.zig \
      --replace-fail "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin" \
        "${
          lib.makeBinPath [
            git
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
  nativeCheckInputs = [ git ];

  preCheck = ''
    export HOME=$TMPDIR
    git config --global user.name nixbld
    git config --global user.email nixbld@localhost
  '';

  postInstall = ''
    wrapProgram $out/bin/ziggity \
      --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, keyboard-driven terminal UI for Git";
    homepage = "https://ziggity.dev";
    changelog = "https://github.com/simoarpe/ziggity/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abuibrahim ];
    mainProgram = "ziggity";
    inherit (zig.meta) platforms;
  };
})
