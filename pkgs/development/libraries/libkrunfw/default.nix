{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  flex,
  bison,
  bc,
  elfutils,
  python3,
  sevVariant ? false,
}:

stdenv.mkDerivation rec {
  pname = "libkrunfw";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    rev = "refs/tags/v${version}";
    hash = "sha256-9oVl4mlJE7QHeehG86pbh7KdShZNUGwlnO75k/F/PQ0=";
  };

  kernelSrc = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.4.7.tar.xz";
    hash = "sha256-3hQ8th3Kp1bAX1b/NRRDFtgQYVgZUYoz40dU8GTEp9g=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)'
  '';

  nativeBuildInputs = [
    flex
    bison
    bc
    python3
    python3.pkgs.pyelftools
  ];

  buildInputs = [
    elfutils
  ];

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
    ]
    ++ lib.optionals sevVariant [
      "SEV=1"
    ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with licenses; [
      lgpl2Only
      lgpl21Only
    ];
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
