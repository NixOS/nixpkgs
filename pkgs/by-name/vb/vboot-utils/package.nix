{
  lib,
  stdenv,
  fetchFromGitiles,
  pkg-config,
  makeWrapper,
  libuuid,
  openssl,
  libyaml,
  nss,
  flashrom,
  xz,
}:
let
  version = "140.16371";
  flashrom_chromeos = flashrom.overrideAttrs (_prev: {
    src =
      let
        versionFormatted = lib.concatStringsSep "-" (lib.versions.splitVersion version);
      in
      fetchFromGitiles {
        url = "https://chromium.googlesource.com/chromiumos/third_party/flashrom";
        rev = "refs/heads/release-R${versionFormatted}.B-master";
        hash = "sha256-7ZpxGe8VqfyyOovuLlET6na0f1ejE9pxC+dHuYdwFww=";
      };

    # requires git
    mesonFlags = _prev.mesonFlags ++ [ (lib.mesonEnable "documentation" false) ];

    # requires specific hardware
    doCheck = false;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vboot-utils";
  inherit version;

  src =
    let
      versionFormatted = lib.concatStringsSep "-" (lib.versions.splitVersion finalAttrs.version);
    in
    fetchFromGitiles {
      rev = "refs/heads/release-R${versionFormatted}.B";
      url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
      hash = "sha256-yW4g0bLeRByGv4UMyyd2nGN+x/WdlW8Yz9KZmfwVr4g=";
    };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libuuid
    libyaml
    openssl
    xz
    nss
    flashrom_chromeos
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    # This apparently doesn't work as expected:
    #  - https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R138-16295.B/Makefile#504
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
    "USE_FLASHROM=1"
    # Upstream has weird opinions about DESTDIR
    # https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/release-R138-16295.B/Makefile#52
    "UB_DIR=${placeholder "out"}/bin"
    "UL_DIR=${placeholder "out"}/lib"
    "UI_DIR=${placeholder "out"}/include/vboot"
    "US_DIR=${placeholder "out"}/share/vboot"
  ];

  postInstall = ''
    mkdir -p $out/share/vboot
    cp -r tests/devkeys* $out/share/vboot/

    wrapProgram $out/bin/crossystem --prefix PATH : ${lib.makeBinPath [ flashrom_chromeos ]}
  '';

  meta = {
    description = "Chrome OS partitioning and kernel signing tools";
    homepage = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
