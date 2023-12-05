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
  version = "3.11.0";

  src = if stdenv.isLinux then fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-p5z3Dc7o/Ja3K0VlOWIPc0qOIU5p+JSxWe7QiVQNkjs=";
  } else fetchurl {
    url = "https://github.com/containers/libkrunfw/releases/download/v${version}/v${version}-with_macos_prebuilts.tar.gz";
    hash = "sha256-XcdsK8L5NwMgelSMhE2YKYxaAin/3p/+GrljGGZpK5Y=";
  };

  kernelSrc = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.9.tar.xz";
    hash = "sha256-kDRJwWTAPw50KqzJIOGFY1heB6KMbLeeD9bDZpX9Q/U=";
  };

  preBuild = ''
    substituteInPlace Makefile \
      --replace 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)' \
      --replace 'gcc' '$(CC)'
  '';

  nativeBuildInputs = [ flex bison bc python3 python3.pkgs.pyelftools ];
  buildInputs = lib.optionals stdenv.isLinux [ elfutils ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SONAME_Darwin=-Wl,-install_name,${placeholder "out"}/lib/libkrunfw.dylib"
  ] ++ lib.optional sevVariant "SEV=1";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with licenses; [ lgpl2Only lgpl21Only ];
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; lib.optionals stdenv.isDarwin [ binaryNativeCode ];
  };
}
