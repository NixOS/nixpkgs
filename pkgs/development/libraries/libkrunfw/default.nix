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
  version = "3.9.0";

  src = if stdenv.isLinux then fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hpVE7g6V3nquZ3R5fQCcfRWuFDHJ3rgisezwdsDMaGg=";
  } else fetchurl {
    url = "https://github.com/containers/libkrunfw/releases/download/v${version}/v${version}-with_macos_prebuilts.tar.gz";
    hash = "sha256-moZ2LYLhZDb8Y8jgWbdgK6SbJ8lY8f356d5vKHc/54Q=";
  };

  kernelSrc = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.6.tar.xz";
    hash = "sha256-Pk2OVh2lcDogWujXsr7WxcZPxCme68v9IEgeY7V9XuM=";
  };

  preBuild = ''
    substituteInPlace Makefile \
      --replace 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)' \
      --replace 'tar xf $(KERNEL_TARBALL)' \
                'tar xf $(KERNEL_TARBALL); sed -i "s|/usr/bin/env bash|$(SHELL)|" $(KERNEL_SOURCES)/scripts/check-local-export' \
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
