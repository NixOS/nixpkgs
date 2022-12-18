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
  version = "3.8.1";

  src = if stdenv.isLinux then fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6jFIfTPjI6Eq0SFdQVxqqoBDW00AsDz/xHN+n6DezME=";
  } else fetchurl {
    url = "https://github.com/containers/libkrunfw/releases/download/v${version}/v${version}-with_macos_prebuilts.tar.gz";
    hash = "sha256-i7btjGBgb93tHshIS02Rp492iB4aG0N4UuRwv6Pkukg=";
  };

  kernelSrc = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.0.6.tar.xz";
    hash = "sha256-hksFry2Gm6c9YanFlZ5FMaFBqyvXshdINnH2Jfl0f6o=";
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
  };
}
