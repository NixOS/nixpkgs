{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, flex
, bison
, bc
, elfutils
, python3
, sevVariant ? false
}:

assert sevVariant -> stdenv.isx86_64;
stdenv.mkDerivation rec {
  pname = "libkrunfw";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ay+E5AgJeA0i3T4JDosDawwtezDGquzAvYEWHGbPidg=";
  };

  kernelSrc = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.59.tar.xz";
    hash = "sha256-5t3GQgVzQNsGs7khwrMb/tLGETWejxRMPlz5w6wzvMs=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)'
  '';

  nativeBuildInputs = [ flex bison bc python3 python3.pkgs.pyelftools ];
  buildInputs = [ elfutils ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optional sevVariant "SEV=1";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with licenses; [ lgpl2Only lgpl21Only ];
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
