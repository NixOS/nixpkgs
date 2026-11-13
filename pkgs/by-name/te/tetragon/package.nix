{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  go_1_27,
  llvm_22,
  clang_22,
  bash,
  writableTmpDirAsHomeHook,
  gitMinimal,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:
let
  go = go_1_27;
  llvm = llvm_22;
  clang = clang_22;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tetragon";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "tetragon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/UnmA3k3NcCEFA+JW19dbQCN9fUYAWkbKV+SGmRmdhw=";
  };

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook
    gitMinimal
    installShellFiles
  ];

  buildInputs = [
    clang
    go
    llvm
  ];

  env = {
    VERSION = finalAttrs.version;
    LOCAL_CLANG = 1;
    LOCAL_CLANG_FORMAT = 1;
    NIX_CFLAGS_COMPILE = "-fno-stack-protector -Qunused-arguments -Wno-default-const-init-var-unsafe";
  };

  buildPhase = ''
    runHook preBuild

    make tetragon
    make tetragon-operator
    make tetra
    make tetragon-bpf

    runHook postBuild
  '';

  # For BPF compilation
  hardeningDisable = [ "zerocallusedregs" ];

  postPatch = ''
    substituteInPlace bpf/Makefile.defs --replace-fail '/bin/bash' '${lib.getExe bash}'
    substituteInPlace pkg/defaults/defaults.go --replace-fail '/var/lib/tetragon/' $out/lib/tetragon/bpf/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/tetragon $out/lib/tetragon/tetragon.tp.d/
    sed -i "s+/usr/local/+$out/+g" install/linux-tarball/usr/local/lib/tetragon/tetragon.conf.d/bpf-lib
    cp -n -r install/linux-tarball/usr/local/lib/tetragon/tetragon.conf.d/ $out/lib/tetragon/
    cp -n -r ./bpf/objs $out/lib/tetragon/bpf
    install -m755 -D ./tetra $out/bin/tetra
    install -m755 -D ./tetragon $out/bin/tetragon
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tetra \
      --bash <($out/bin/tetra completion bash) \
      --fish <($out/bin/tetra completion fish) \
      --zsh <($out/bin/tetra completion zsh)
    installShellCompletion --cmd tetragon \
      --bash <($out/bin/tetragon completion bash) \
      --fish <($out/bin/tetragon completion fish) \
      --zsh <($out/bin/tetragon completion zsh)
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  versionCheckProgram = "${placeholder "out"}/bin/tetra";
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Real-time, eBPF-based Security Observability and Runtime Enforcement tool";
    homepage = "https://github.com/cilium/tetragon";
    license = lib.licenses.asl20;
    mainProgram = "tetragon";
    maintainers = with lib.maintainers; [
      gangaram
      RoGreat
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
