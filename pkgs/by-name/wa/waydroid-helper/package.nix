{
  lib,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  libxml2,
  python3Packages,
  appstream,
  glib,
  cmake,
  dbus,
  systemd,
  bash,
  bindfs,
  e2fsprogs,
  fakeroot,
  fuse,
  gobject-introspection,
  unzip,
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid-helper";
  version = "0.2.3";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "ayasa520";
    repo = "waydroid-helper";
    tag = "v${version}";
    hash = "sha256-QxtCxujf7S3YRx/4rRMecFBomP+9tqrIBdYhc3WQT20=";
  };

  postPatch = ''
    substituteInPlace dbus/meson.build \
      --replace-fail "dbus_policy_dir," "'$out/share/dbus-1/system.d'," \
      --replace-fail "dbus_service_dir," "'$out/share/dbus-1/system-services',"
    substituteInPlace systemd/meson.build \
      --replace-fail ": systemd_system_unit_dir" ": '$out/lib/systemd/system'" \
      --replace-fail ": systemd_user_unit_dir" ": '$out/lib/systemd/user'"
    substituteInPlace systemd/{system/waydroid-mount,user/waydroid-monitor}.service \
      --replace-fail "/usr/bin/waydroid-helper" "$out/bin/waydroid-helper"
    # com.jaoushingan.WaydroidHelper.desktop: component-name-missing, description-first-para-too-short
    # url-homepage-missing, desktop-app-launchable-omitted, content-rating-missing, developer-info-missing
    sed -i '/test(/{N;/Validate appstream file/!b;:a;N;/)/!ba;d}' data/meson.build
  '';

  nativeBuildInputs = [
    appstream
    glib
    cmake
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    libadwaita
    dbus
    bash
    systemd
  ];

  dontUseCmakeConfigure = true;

  dependencies = with python3Packages; [
    pygobject3
    httpx
    pyyaml
    aiofiles
    dbus-python
  ];

  strictDeps = true;

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        bindfs
        e2fsprogs
        fakeroot
        fuse
        unzip
      ]
    }"
  ];

  postInstallCheck = ''
    mesonCheckPhase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "User-friendly way to configure Waydroid and install extensions, including Magisk and ARM translation";
    homepage = "https://github.com/ayasa520/waydroid-helper";
    changelog = "https://github.com/ayasa520/waydroid-helper/releases/tag/${src.tag}";
    mainProgram = "waydroid-helper";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
  };
}
