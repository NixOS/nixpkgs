{
  lib,
  stdenv,
  fetchFromGitiles,
  pkg-config,
  libuuid,
  openssl,
  libyaml,
  xz,
}:

stdenv.mkDerivation {
  pname = "vboot_reference";
  version = "135.16209";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    rev = "bf4b21294a1c2c6b94f400819d3fce4a905b3afe"; # refs/heads/release-R135-16209.B
    hash = "sha256-frg7NkK173wAHJRedtbJI5jI8Kee/VkByh5DCUzD9OA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libuuid
    libyaml
    openssl
    xz
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    # This apparently doesn't work as expected:
    #  - https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R135-16209.B/Makefile#493
    # Let's apply the same flag manually.
    "-Wno-error=deprecated-declarations"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "ar qc" '${stdenv.cc.bintools.targetPrefix}ar qc'
    # Drop flag unrecognized by GCC 9 (for e.g. aarch64-linux)
    substituteInPlace Makefile \
      --replace "-Wno-unknown-warning" ""
  '';

  preBuild = ''
    patchShebangs scripts
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "HOST_ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    "USE_FLASHROM=0"
    # Upstream has weird opinions about DESTDIR
    # https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R135-16209.B/Makefile#51
    "UB_DIR=${placeholder "out"}/bin"
    "UL_DIR=${placeholder "out"}/lib"
    "UI_DIR=${placeholder "out"}/include/vboot"
    "US_DIR=${placeholder "out"}/share/vboot"
  ];

  postInstall = ''
    mkdir -p $out/share/vboot
    cp -r tests/devkeys* $out/share/vboot/
  '';

  meta = with lib; {
    description = "Chrome OS partitioning and kernel signing tools";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
