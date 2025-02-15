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
  version = "133.16151";

  pname = "vboot_reference";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    rev = "3f94e2c7ed58c4e67d6e7dc6052ec615dbbb9bb4"; # refs/heads/release-R133-16151.B
    hash = "sha256-47dMD6wTwQRVP1lufBoMbPd5HocKsrqxMdlMJd5pWIo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libuuid
    libyaml
    openssl
    xz
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "ar qc" '${stdenv.cc.bintools.targetPrefix}ar qc'
    # Drop flag unrecognized by GCC 9 (for e.g. aarch64-linux)
    substituteInPlace Makefile \
      --replace-fail "-Wno-unknown-warning" ""

    patchShebangs scripts
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "HOST_ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    "USE_FLASHROM=0"
    # Upstream has weird opinions about DESTDIR
    # https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R133-16151.B/Makefile#51
    "UB_DIR=${placeholder "out"}/bin"
    "UL_DIR=${placeholder "out"}/lib"
    "UI_DIR=${placeholder "out"}/include/vboot"
    "US_DIR=${placeholder "out"}/share/vboot"
  ];

  postInstall = ''
    mkdir -p $out/share/vboot
    cp -r tests/devkeys* $out/share/vboot/
  '';

  meta = {
    description = "Chrome OS partitioning and kernel signing tools";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
