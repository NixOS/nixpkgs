{
  lib,
  stdenv,
  fetchFromGitiles,
  pkg-config,
  makeBinaryWrapper,
  libuuid,
  openssl,
  libyaml,
  xz,
  flashrom,
  nss,

  withFlashrom ? true,
  withNss ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vboot-utils";
  version = "157.16852";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference";
    rev = "refs/heads/release-R${finalAttrs.passthru.versionFormatted}.B";
    hash = "sha256-qifGCywhtwmgSh0d7ZL+xJu8WE1BilWlsCuVhX2luV4=";
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    libuuid
    libyaml
    openssl
    xz
  ]
  ++ lib.optional withNss nss
  ++ lib.optional withFlashrom finalAttrs.passthru.flashromChromeos;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace {firmware,host,tests}/Makefile.inc \
      --replace-fail "ar qcT" '${stdenv.cc.targetPrefix}ar qcT'
    patchShebangs scripts
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "HOST_ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    "USE_FLASHROM=${if withFlashrom then "1" else "0"}"
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
  ''
  + lib.optionalString withFlashrom ''
    wrapProgram $out/bin/crossystem \
      --prefix PATH : ${lib.makeBinPath [ finalAttrs.passthru.flashromChromeos ]}
  '';

  passthru = {
    versionFormatted = lib.concatStringsSep "-" (lib.versions.splitVersion finalAttrs.version);
    flashromChromeos = flashrom.overrideAttrs (prev: {
      src = fetchFromGitiles {
        url = "https://chromium.googlesource.com/chromiumos/third_party/flashrom";
        rev = "refs/heads/release-R${finalAttrs.passthru.versionFormatted}.B-master";
        hash = "sha256-V4I9NGarq1vUwjeXTbjd8KPqsP0Pp/UnwfFHryHnFA4=";
      };

      outputs = lib.filter (output: output != "doc") prev.outputs;

      # requires git
      mesonFlags = prev.mesonFlags ++ [ (lib.mesonEnable "documentation" false) ];

      # requires specific hardware
      doCheck = false;
    });
  };

  meta = {
    description = "Chrome OS partitioning and kernel signing tools";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jmbaur ];
  };
})
