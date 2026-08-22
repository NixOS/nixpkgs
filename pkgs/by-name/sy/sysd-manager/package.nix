{
  lib,
  rustPlatform,
  pkg-config,
  gtk4,
  libadwaita,
  gtksourceview5,
  systemd,
  gettext,
  glib,
  gsettings-desktop-schemas,
  fetchFromGitHub,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sysd-manager";
  version = "2.20.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "plrigaux";
    repo = "sysd-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FkqWQ66QdUCo9eXtfwxP5IRB5elZn1F0GtED67fvnyA=";
  };

  cargoHash = "sha256-EJ64ZGPmQM+Gs5O4WkUMJmT8zDRyF4ZjzXGi1Jw+ovA=";

  nativeBuildInputs = [
    pkg-config
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    gtksourceview5
    systemd
    gettext
    glib
    gsettings-desktop-schemas
  ];

  doCheck = true;

  nativeCheckInputs = [ systemd ];

  cargoBuildFlags = [
    "--features"
    "default"
    "--package"
    "sysd-manager"
    "--package"
    "sysd-manager-proxy"
  ];

  postBuild = ''
    cargo run -p transtools -- packfiles
    cargo run -p transtools -- mo
  '';

  postInstall =
    let
      conf_file = "$out/share/dbus-1/system.d/io.github.plrigaux.SysDManager.conf";
      service_file = "$out/lib/systemd/system/sysd-manager-proxy.service";
      bus_name = "io.github.plrigaux.SysDManager";
    in
    ''

      install -Dm644 data/icons/hicolor/scalable/apps/io.github.plrigaux.sysd-manager.svg  "$out/share/icons/hicolor/scalable/apps/io.github.plrigaux.sysd-manager.svg"
      install -Dm644 target/loc/io.github.plrigaux.sysd-manager.desktop $out/share/applications/io.github.plrigaux.sysd-manager.desktop
      install -Dm644 target/loc/io.github.plrigaux.sysd-manager.metainfo.xml $out/share/metainfo/io.github.plrigaux.sysd-manager.metainfo.xml
      install -Dm644 data/schemas/io.github.plrigaux.sysd-manager.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
      glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/

      install -Dm644 sysd-manager-proxy/data/io.github.plrigaux.SysDManager.conf "${conf_file}"
      install -Dm644 target/loc/io.github.plrigaux.SysDManager.policy $out/share/polkit-1/actions/io.github.plrigaux.SysDManager.policy
      install -Dm644 sysd-manager-proxy/data/50-io.github.plrigaux.SysDManager.rules $out/share/polkit-1/rules.d/50-io.github.plrigaux.SysDManager.rules
      install -Dm644 sysd-manager-proxy/data/sysd-manager-proxy.service "${service_file}"


      substituteInPlace "${conf_file}" \
        --replace-fail '{BUS_NAME}' "${bus_name}" \
        --replace-fail '{DESTINATION}' "${bus_name}" \
        --replace-fail '{INTERFACE}' "${bus_name}"

      substituteInPlace "${service_file}" \
        --replace-fail '{ENVIRONMENT}' "" \
        --replace-fail '{EXECUTABLE}' "$out/bin/sysd-manager-proxy" \
        --replace-fail '{DESTINATION}' "${bus_name}" \
        --replace-fail '{SERVICE_ID}' 'sysd-manager-proxy'

      cp -r "./target/locale" "$out/share/"
    '';

  meta = {
    description = "A systemd GUI to manage service, timer, socket and other units.";
    homepage = "https://github.com/plrigaux/sysd-manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ plrigaux ];
    platforms = lib.platforms.linux;
    mainProgram = "sysd-manager";
  };
})
