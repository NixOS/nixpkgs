{
  lib,
  stdenv,
  aws-lc,
  callPackage,
  capnproto,
  cctools,
  fetchFromGitHub,
  installShellFiles,
  llvmPackages,
  pkg-config,
  protobuf,
  rustPlatform,
  xcbuild,
  zig_0_17,
  zstd,
}:
let
  pname = "turbo-unwrapped";
  version = "2.11.10";

  ghostty-src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    rev = "5147c0a503cdeed7615cce245cdd815ed7a6b692";
    hash = "sha256-+x4rn2cqqGfd0MELw3pzythS7egsVxWznirx4yvISSI=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turborepo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AK1I+bf0IUFLlcctcyUVmK1XChzC3IUL3noUvXC9Tpc=";
  };

  patches = [
    # Zig has removed the ability to use `--global-cache-dir` with
    # `zig build`. It only allows the global cache dir to be passed
    # with `ZIG_GLOBAL_CACHE_DIR`.
    ./fix-zig-global-cache-dir.patch
  ];

  cargoHash = "sha256-HOzHVpDud/4BIYL2VMiPTFdi4ISz0jdC5U0VLJXnH/U=";

  nativeBuildInputs = [
    capnproto
    installShellFiles
    pkg-config
    protobuf
    zig_0_17
  ]
  # https://github.com/vercel/turbo/blob/ea740706e0592b3906ab34c7cfa1768daafc2a84/CONTRIBUTING.md#linux-dependencies
  ++ lib.optionals stdenv.hostPlatform.isLinux [ llvmPackages.bintools ]
  # Tools required for building `libghostty-vt-sys` on darwin.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  env = {
    # Use vendored ghostty source and dependencies.
    GHOSTTY_SOURCE_DIR = ghostty-src;
    GHOSTTY_ZIG_SYSTEM_DIR = callPackage ./deps.nix {
      name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
    };
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
    inherit ghostty-src;
    updateScript = ./update.sh;
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
