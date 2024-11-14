{ lib, stdenv, fetchFromGitiles, pkg-config, libuuid, openssl, libyaml, xz }:

stdenv.mkDerivation rec {
  version = "111.15329";

  pname = "vboot_reference";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    rev = "1a1cb5c9a38030a5868e2aaad295c68432c680fd"; # refs/heads/release-R111-15329.B
    sha256 = "sha256-56/hqqFiKHw0/ah0D20U1ueIU2iq8I4Wn5DiEWxB9qA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libuuid libyaml openssl xz ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    # This apparently doesn't work as expected:
    #  - https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R111-15329.B/Makefile#439
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
    # https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R111-15329.B/Makefile#51
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
