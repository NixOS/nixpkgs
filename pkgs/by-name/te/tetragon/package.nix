{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  go,
  llvm_16,
  clang_16,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetragon";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "tetragon";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-KOR5MMRnhrlcMPqRjzjSJXvitiZQ8/tlxEnBiQG2x/Q=";
  };

  buildInputs = [
    clang_16
    go
    llvm_16
    pkg-config
  ];

  env.NIX_CFLAGS_COMPILE = "-fno-stack-protector -Qunused-arguments";

  buildPhase = ''
    runHook preBuild
    export HOME=$TMP
    export LOCAL_CLANG=1
    export LOCAL_CLANG_FORMAT=1
    make tetragon
    make tetragon-operator
    make tetra
    make tetragon-bpf
    runHook postBuild
  '';

  # For BPF compilation
  hardeningDisable = [
    "zerocallusedregs"
  ];

  postPatch = ''
    substituteInPlace bpf/Makefile --replace '/bin/bash' '${lib.getExe bash}'
    substituteInPlace pkg/defaults/defaults.go --replace '/var/lib/tetragon/' $out/lib/tetragon/bpf/
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

  meta = with lib; {
    description = "Real-time, eBPF-based Security Observability and Runtime Enforcement tool";
    homepage = "https://github.com/cilium/tetragon";
    license = licenses.asl20;
    mainProgram = "tetragon";
    maintainers = with maintainers; [ gangaram ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
