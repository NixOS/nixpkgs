{
  lib,
  SDL2,
  SDL2_image,
  fetchFromGitHub,
  gettext,
  glib,
  gtk3,
  libGLU,
  libdrm,
  libepoxy,
  libpcap,
  libsamplerate,
  libslirp,
  mesa,
  meson,
  ninja,
  openssl,
  perl,
  pkg-config,
  python3Packages,
  stdenv,
  vte,
  which,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xemu";
  version = "0.7.131";

  src = fetchFromGitHub {
    owner = "xemu-project";
    repo = "xemu";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-xupCEqTovrEA7qEEr9nBjO7iIbTeXv59cg99W6Nc/54=";
  };

  nativeBuildInputs =
    [
      SDL2
      meson
      ninja
      perl
      pkg-config
      which
      wrapGAppsHook3
    ]
    ++ (with python3Packages; [
      python
      pyyaml
    ]);

  buildInputs = [
    SDL2
    SDL2_image
    gettext
    glib
    gtk3
    libGLU
    libdrm
    libepoxy
    libpcap
    libsamplerate
    libslirp
    mesa
    openssl
    vte
  ];

  configureFlags = [
    "--disable-strip"
    "--meson=meson"
    "--target-list=i386-softmmu"
    "--disable-werror"
  ];

  buildFlags = [ "qemu-system-i386" ];

  separateDebugInfo = true;

  dontUseMesonConfigure = true;

  setOutputFlags = false;

  strictDeps = true;

  postPatch = ''
    patchShebangs .
    substituteInPlace ./scripts/xemu-version.sh \
      --replace 'date -u' "date -d @$SOURCE_DATE_EPOCH '+%Y-%m-%d %H:%M:%S'"
  '';

  preConfigure =
    ''
      configureFlagsArray+=("--extra-cflags=-DXBOX=1 -Wno-error=redundant-decls")
    ''
    +
      # When the data below can't be obtained through git, the build process tries
      # to run `XEMU_COMMIT=$(cat XEMU_COMMIT)` (and similar)
      ''
        echo '${finalAttrs.version}' > XEMU_VERSION
      '';

  preBuild = ''
    cd build
    substituteInPlace ./build.ninja --replace /usr/bin/env $(which env)
  '';

  installPhase =
    let
      installIcon = resolution: ''
        install -Dm644 -T ../ui/icons/xemu_${resolution}.png \
          $out/share/icons/hicolor/${resolution}/apps/xemu.png
      '';
    in
    ''
      runHook preInstall

      install -Dm755 -T qemu-system-i386 $out/bin/xemu
    ''
    + (lib.concatMapStringsSep "\n" installIcon [
      "16x16"
      "24x24"
      "32x32"
      "48x48"
      "128x128"
      "256x256"
      "512x512"
    ])
    + "\n"
    + ''
      install -Dm644 -T ../ui/xemu.desktop $out/share/applications/xemu.desktop

      runHook postInstall
    '';

  meta = {
    homepage = "https://xemu.app/";
    description = "Original Xbox emulator";
    longDescription = ''
      A free and open-source application that emulates the original Microsoft
      Xbox game console, enabling people to play their original Xbox games on
      Windows, macOS, and Linux systems.
    '';
    changelog = "https://github.com/xemu-project/xemu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xemu";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
# TODO: investigate failure when using __structuredAttrs
