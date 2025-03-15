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
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid-helper";
  version = "0.1.2";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "ayasa520";
    repo = "waydroid-helper";
    tag = "v${version}";
    hash = "sha256-dYduO5Wi8Ia/pR1xQKPhC6Ek/1Q9fm2RaVuhm9KYiU0=";
  };

  postPatch = ''
    substituteInPlace dbus/meson.build \
      --replace-fail "dbus_policy_dir," "'$out/share/dbus-1/system.d'," \
      --replace-fail "dbus_service_dir," "'$out/share/dbus-1/system-services',"
    substituteInPlace systemd/meson.build \
      --replace-fail ": systemd_system_unit_dir" ": '$out/lib/systemd/system'" \
      --replace-fail ": systemd_user_unit_dir" ": '$out/lib/sysusers.d'"
    # com.jaoushingan.WaydroidHelper.desktop: component-name-missing, description-first-para-too-short
    # url-homepage-missing, desktop-app-launchable-omitted, content-rating-missing, developer-info-missing
    sed -i '/test(/{N;/Validate appstream file/!b;:a;N;/)/!ba;d}' data/meson.build
    substituteInPlace waydroid_helper/waydroid-cli.in \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
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
  ];

  buildInputs = [
    libxml2
    libadwaita
    dbus
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

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postInstallCheck = ''
    mesonCheckPhase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Provides a user-friendly way to configure Waydroid and install extensions";
    homepage = "https://github.com/ayasa520/waydroid-helper";
    changelog = "https://github.com/ayasa520/waydroid-helper/releases/tag/${src.tag}";
    mainProgram = "waydroid-helper";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
  };
}
