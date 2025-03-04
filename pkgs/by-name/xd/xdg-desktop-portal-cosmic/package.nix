{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  libcosmicAppHook,
  pkg-config,
  util-linux,
  libgbm,
  pipewire,
  gst_all_1,
  coreutils,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-ymBmnSEXGCNbLTIVzHP3tjKAG0bgvEFU1C8gnxiow98=";
  };

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-02-20";
    VERGEN_GIT_SHA = finalAttrs.src.rev;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-FO/GIzv9XVu8SSV+JbOf98UX/XriRgqTthtzvRIWNjo=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
    util-linux
  ];

  buildInputs = [
    libgbm
    pipewire
  ];

  checkInputs = [ gst_all_1.gstreamer ];

  # TODO: Remove this when updating to the next version
  patches = [
    (fetchpatch {
      name = "cosmic-portal-fix-examples-after-ashpd-api-update.patch";
      url = "https://github.com/pop-os/xdg-desktop-portal-cosmic/commit/df831ce7a48728aa9094fa1f30aed61cf1cc6ac3.diff?full_index=1";
      hash = "sha256-yRrB3ds9TtN1OBZEZbnE6h2fkPyP4PP2IJ17n+0ugEo=";
    })
  ];

  # Also modifies the functionality by replacing 'false' with 'true' to enable the portal to start properly.
  postPatch = ''
    substituteInPlace data/org.freedesktop.impl.portal.desktop.cosmic.service \
      --replace-fail 'Exec=/bin/false' 'Exec=${lib.getExe' coreutils "true"}'
  '';

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nyabinary
      HeitorAugustoLN
    ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = lib.platforms.linux;
  };
})
