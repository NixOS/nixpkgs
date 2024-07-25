{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, flex
, bison
, bc
, cpio
, perl
, elfutils
, python3
, sevVariant ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw";
  version = "4.0.0-unstable-2024-06-10";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    rev = "12236fa4caa42423ff3081b6179aa0a5f37c67c9";
    hash = "sha256-Vcbg2zBVMQsiAQF/cEEIRMqppMBVGnqUBlDquGzRBsc=";
  };

  kernelSrc = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.32.tar.xz";
    hash = "sha256-qqgk6vB/YZEdIrdf8JCkA8PdC9c+I5M+C7qLWXFDbOE=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)'
  '';

  nativeBuildInputs = [
    flex
    bison
    bc
    cpio
    perl
    python3
    python3.pkgs.pyelftools
  ];

  buildInputs = [
    elfutils
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optionals sevVariant [
    "SEV=1"
  ];

  # Fixes https://github.com/containers/libkrunfw/issues/55
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.targetPlatform.isAarch64 "-march=armv8-a+crypto";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with licenses; [ lgpl2Only lgpl21Only ];
    maintainers = with maintainers; [ nickcao RossComputerGuy ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
})
