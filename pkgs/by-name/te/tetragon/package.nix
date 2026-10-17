{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  go,
  llvm,
  clang_20,
  bash,
  writableTmpDirAsHomeHook,
  gitMinimal,
  installShellFiles,
  nix-update-script,
}:
let
  # https://github.com/cilium/tetragon/issues/5389
  clang = clang_20;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tetragon";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "tetragon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ls+nEx5pGCpirhXve6taKW/5A1fiLGLMT7KjYPEiWHE=";
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
