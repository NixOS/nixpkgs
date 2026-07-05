{
  lib,
  stdenv,
  capnproto,
  cctools,
  fetchFromGitHub,
  installShellFiles,
  llvmPackages,
  nix-update-script,
  protobuf,
  rustPlatform,
  xcbuild,
  zig_0_15,
}:
let
  pname = "turbo-unwrapped";
  version = "2.10.12";

  ghostty-src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    rev = "a887df42c56f6de86c0fe6da9c4eeca37931e083";
    hash = "sha256-1Zz65SCk3rkJ9+Q0MmyNOTNiDSLBRIHRd3IvFM4iNXw=";
  };
  ghostty-deps = zig_0_15.fetchDeps {
    inherit pname version;
    src = ghostty-src;
    fetchAll = true;
    hash = "sha256-PnM+hZIlLyQwK8vJgd/Bhjt1lNIz06T8FahwliRmMrY=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turborepo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KDrqW6cu57aZCB7Nypm7mjQrJze40IEzrUeCZ1Crvbg=";
  };

  cargoHash = "sha256-oDRckEe9gVlC3B9jRpMsvs4qjcRolIKvYQdf3mIw2hI=";

  nativeBuildInputs = [
    capnproto
    installShellFiles
    protobuf
    zig_0_15.hook
  ]
  # https://github.com/vercel/turbo/blob/ea740706e0592b3906ab34c7cfa1768daafc2a84/CONTRIBUTING.md#linux-dependencies
  ++ lib.optionals stdenv.hostPlatform.isLinux [ llvmPackages.bintools ]
  # Tools required for building `libghostty-vt-sys` on darwin.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  env = {
    # Use vendored ghostty source and dependencies.
    GHOSTTY_SOURCE_DIR = ghostty-src;
    GHOSTTY_ZIG_SYSTEM_DIR = ghostty-deps;
    # nightly features are used
    RUSTC_BOOTSTRAP = 1;
  };

  cargoBuildFlags = [
    "--package"
    "turbo"
  ];

  # Browser tests time out with chromium and google-chrome
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd turbo \
      --bash <($out/bin/turbo completion bash) \
      --fish <($out/bin/turbo completion fish) \
      --zsh <($out/bin/turbo completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    changelog = "https://github.com/vercel/turborepo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      getchoo
      hythera
    ];
    mainProgram = "turbo";
  };
})
