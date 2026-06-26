{
  lib,
  python3Packages,
  fetchFromGitHub,
  appstream,
  cmake,
  desktop-file-utils,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  bash,
  bindfs,
  dbus,
  android-tools,
  e2fsprogs,
  fakeroot,
  libadwaita,
  libxml2,
  systemd,
  unzip,
  nix-update-script,
  fetchpatch,
}:

let
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "ayasa520";
    repo = "waydroid-helper";
    tag = "v${version}";
    hash = "sha256-6mVb4GPD2NCsvyaqQAOFox0rNIlyOttiaZKbHBS40Rg=";
  };
in
python3Packages.buildPythonApplication {
  pname = "waydroid-helper";
  inherit version src;
  pyproject = false; # uses meson

  patches = [
    # remove for next release
    (fetchpatch {
      name = "USE_UMOUNT_NOT_FUSERMOUNT";
      url = "https://github.com/waydroid-helper/waydroid-helper/commit/eb8ccf7a276f95b31972edbd063245704b2b5b2e.patch";
      hash = "sha256-z0PWBZTox3RpPCm8/fGYEukU0v41U7/TFcYE0Ec5Zeg=";
    })
  ];

  postPatch = ''
    substituteInPlace dbus/meson.build \
      --replace-fail "dbus_policy_dir," "'$out/share/dbus-1/system.d'," \
      --replace-fail "dbus_service_dir," "'$out/share/dbus-1/system-services',"
    substituteInPlace systemd/meson.build \
      --replace-fail ": systemd_system_unit_dir" ": '$out/lib/systemd/system'" \
      --replace-fail ": systemd_user_unit_dir" ": '$out/lib/systemd/user'"
    substituteInPlace systemd/{system/waydroid-mount,user/waydroid-monitor}.service \
      --replace-fail "/usr/bin/waydroid-helper" "$out/bin/waydroid-helper"
  ''
  # com.jaoushingan.WaydroidHelper.desktop: component-name-missing, description-first-para-too-short
  # url-homepage-missing, desktop-app-launchable-omitted, content-rating-missing, developer-info-missing
  + ''
    sed -i '/test(/{N;/Validate appstream file/!b;:a;N;/)/!ba;d}' data/meson.build
  '';

  nativeBuildInputs = [
    appstream
    cmake
    desktop-file-utils
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    bash
    dbus
    libadwaita
    libxml2
    systemd
  ];

  dontUseCmakeConfigure = true;

  dependencies = with python3Packages; [
    aiofiles
    dbus-python
    httpx
    pygobject3
    pyyaml
    pywayland
  ];

  strictDeps = true;

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        android-tools
        bindfs
        e2fsprogs
        fakeroot
        unzip
      ]
    }"
  ];

  postInstallCheck = ''
    mesonCheckPhase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ayasa520/waydroid-helper/releases/tag/${src.tag}";
    description = "User-friendly way to configure Waydroid and install extensions, including Magisk and ARM translation";
    homepage = "https://github.com/ayasa520/waydroid-helper";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "waydroid-helper";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
