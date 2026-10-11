{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  git,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggity";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "simoarpe";
    repo = "ziggity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vYEK0NYA5y0RCGW/buLCr1QdDNKuOPOowkz+4SWCzW0=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-zExtFneFH0ATmKeWCHtjeTFElO88MehRNVIqZUF1YsM=";
  };

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
