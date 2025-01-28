{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  glib,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "waytrogen";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "waytrogen";
    tag = version;
    hash = "sha256-tq5cC0Z0kmrYopOGbdoAERBHQXrAw799zWdQP06rTYw=";
  };

  cargoHash = "sha256-05YfQBezDbQ8KfNvl/4Av5vf/rxJU3Ej6RDgSnSfjtM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
  ];

  postBuild = ''
    install -Dm644 org.Waytrogen.Waytrogen.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
  '';

  postInstall = ''
    install -Dm644 waytrogen.desktop $out/share/applications/waytrogen.desktop
    install -Dm644 README-Assets/WaytrogenLogo.svg $out/share/icons/hicolor/scalable/apps/waytrogen.svg
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightning fast wallpaper setter for Wayland";
    longDescription = ''
      A GUI wallpaper setter for Wayland that is a spiritual successor
      for the minimalistic wallpaper changer for X11 nitrogen. Written purely
      in the Rust 🦀 programming language. Supports hyprpaper, swaybg, mpvpaper and swww wallpaper changers.
    '';
    homepage = "https://github.com/nikolaizombie1/waytrogen";
    changelog = "https://github.com/nikolaizombie1/waytrogen/releases/tag/${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "waytrogen";
    platforms = lib.platforms.linux;
  };
}
