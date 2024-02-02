{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, go
, llvm_16
, clang_16
, bash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetragon";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "tetragon";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-KOR5MMRnhrlcMPqRjzjSJXvitiZQ8/tlxEnBiQG2x/Q=";
  };  

  buildInputs = [
    clang_16
    go
    llvm_16
    pkg-config
  ];
  buildPhase = ''
    export HOME=$TMP
    export LOCAL_CLANG=1
    export LOCAL_CLANG_FORMAT=1
    make tetragon
    make tetragon-operator
    make tetra
    NIX_CFLAGS_COMPILE="-fno-stack-protector -Qunused-arguments" make tetragon-bpf
  '';

  postPatch = ''
    substituteInPlace bpf/Makefile --replace '/bin/bash' '${bash}/bin/bash'
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/lib/tetragon
    sed -i "s+/usr/local/+$out/+g" install/linux-tarball/usr/local/lib/tetragon/tetragon.conf.d/bpf-lib
    cp -n -r install/linux-tarball/usr/local/lib/tetragon/tetragon.conf.d/ $out/lib/tetragon/
    cp -n -r ./bpf/objs $out/lib/tetragon/bpf
    mkdir -p $out/lib/tetragon/tetragon.tp.d/
    install -m755 -D ./tetra $out/bin/tetra
    install -m755 -D ./tetragon $out/bin/tetragon
  '';

  meta = with lib; {
    homepage = "https://github.com/cilium/tetragon";
    description = "Real-time, eBPF-based Security Observability and Runtime Enforcement tool";
    mainProgram = "tetragon";
    maintainers = with maintainers; [ gangaram ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = {
      url = "https://github.com/cilium/tetragon/blob/main/LICENSE";
    };
  };
})

