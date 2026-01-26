{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  libbpf,
  elfutils,
  zlib,
  libpcap,
  bpftools,
  llvmPackages,
  pkg-config,
  m4,
  emacs-nox,
  wireshark-cli,
  nukeReferences,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdp-tools";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "xdp-project";
    repo = "xdp-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Smu93zwZN2jn9bLkVRpyubqTUh8VnVFMGqzc9myryLU=";
  };

  outputs = [
    "out"
    "lib"
  ];

  buildInputs = [
    libbpf
    elfutils
    libpcap
    zlib
  ];

  depsBuildBuild = [
    emacs-nox # to generate man pages from .org
  ];
  nativeBuildInputs = [
    bpftools
    llvmPackages.llvm
    pkg-config
    m4
    nukeReferences
  ];
  nativeCheckInputs = [
    wireshark-cli # for tshark
  ];

  hardeningDisable = [ "zerocallusedregs" ];
  # When building BPF, the default CC wrapper is interfering a bit too much.
  BPF_CFLAGS = "-fno-stack-protector -Wno-error=unused-command-line-argument";
  # When cross compiling, configure prefers the unwrapped clang unless told otherwise.
  CLANG = lib.getExe buildPackages.llvmPackages.clang;

  PRODUCTION = 1;
  DYNAMIC_LIBXDP = 1;
  FORCE_SYSTEM_LIBBPF = 1;
  FORCE_EMACS = 1;

  makeFlags = [
    "PREFIX=$(out)"
    "LIBDIR=$(lib)/lib"
  ];

  postInstall = ''
    # Note that even the static libxdp would refer to BPF_OBJECT_DIR ?=$(LIBDIR)/bpf
    rm "$lib"/lib/*.a
    # Drop unfortunate references to glibc.dev/include at least from $lib
    nuke-refs "$lib"/lib/bpf/*.o
  '';

  meta = {
    homepage = "https://github.com/xdp-project/xdp-tools";
    description = "Library and utilities for use with XDP";
    license = with lib.licenses; [
      gpl2Only
      lgpl21
      bsd2
    ];
    maintainers = with lib.maintainers; [
      tirex
      vcunat
      vifino
    ];
    platforms = lib.platforms.linux;
  };
})
