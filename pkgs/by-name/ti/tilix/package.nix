{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  pkg-config,
  ldc,
  dconf,
  dbus,
  gsettings-desktop-schemas,
  desktop-file-utils,
  gettext,
  gtkd,
  libsecret,
  wrapGAppsHook3,
  libunwind,
  appstream,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilix";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = finalAttrs.version;
    hash = "sha256-KP0ojwyZ5FaYKW0nK9mGGAiz1h+gTbfjCUDCgN2LAO8=";
  };

  # Default upstream else LDC fails to link
  mesonBuildType = [
    "debugoptimized"
  ];

  nativeBuildInputs = [
    desktop-file-utils
    ldc
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    appstream
  ];

  buildInputs = [
    dbus
    gettext
    dconf
    gsettings-desktop-schemas
    gtkd
    libsecret
    libunwind
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    substituteInPlace $out/share/applications/com.gexperts.Tilix.desktop \
      --replace "Exec=tilix" "Exec=$out/bin/tilix"
  '';

  passthru.tests.test = nixosTests.terminal-emulators.tilix;

  meta = with lib; {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = "https://gnunn1.github.io/tilix-web";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      midchildan
      jtbx
    ];
    platforms = platforms.linux;
    mainProgram = "tilix";
  };
})
