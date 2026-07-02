{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
  pango,
  nix-update-script,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sysd-manager";
  version = "2.20.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "plrigaux";
    repo = "sysd-manager";
    tag = finalAttrs.version;
    hash = "sha256-D7oI7ajwx6mtoUIMgW1OfnJ28/p/qm86XF8w90cNNpM=";
  };

  cargoHash = "sha256-j5KeHK66RtyuVem+6N3dRI+jjfCt1Bu2CFmDg9SqhCc=";

  checkFlags = [
    # Broken upstream tests
    "--skip=widget::creator::first_page::tests::test_unit_name_regex"
    "--skip=widget::unit_list::tests::test_id_extracts_correct_substring"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    install -Dm644 data/schemas/io.github.plrigaux.sysd-manager.gschema.xml \
      $out/share/glib-2.0/schemas/io.github.plrigaux.sysd-manager.gschema.xml
    glib-compile-schemas $out/share/glib-2.0/schemas

    install -Dm644 data/applications/io.github.plrigaux.sysd-manager.desktop \
      $out/share/applications/io.github.plrigaux.sysd-manager.desktop

    install -Dm644 data/icons/hicolor/scalable/apps/io.github.plrigaux.sysd-manager.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.plrigaux.sysd-manager.svg

    install -Dm644 data/metainfo/io.github.plrigaux.sysd-manager.metainfo.xml \
      $out/share/metainfo/io.github.plrigaux.sysd-manager.metainfo.xml
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  nativeCheckInputs = [
    systemd
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
    pango
    systemd
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A user-friendly GUI to manage systemd units";
    homepage = "https://github.com/plrigaux/sysd-manager";
    changelog = "https://github.com/plrigaux/sysd-manager/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "sysd-manager";
    platforms = lib.platforms.linux;
  };
})
