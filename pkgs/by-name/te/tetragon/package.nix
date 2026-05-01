{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  go,
  llvm,
  clang,
  bash,
  writableTmpDirAsHomeHook,
  gitMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetragon";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "tetragon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-riuSByvMpbukA+pwbzecnyUvZGtPR6lLEA1s2oBnI+A=";
  };

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook
    gitMinimal
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

    runHook postInstall
  '';

  meta = {
    description = "Real-time, eBPF-based Security Observability and Runtime Enforcement tool";
    homepage = "https://github.com/cilium/tetragon";
    license = lib.licenses.asl20;
    mainProgram = "tetragon";
    maintainers = with lib.maintainers; [ gangaram ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
