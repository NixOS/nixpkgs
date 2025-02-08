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
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "waytrogen";
    tag = version;
    hash = "sha256-/NvLgC1IB3YrilnuuZFMuDYaUDQ4fDrtYNf1xL8H+Ng=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cdomE3K8T1urvRK1TAm+IvnKC8ZuPgEVnN3TzlJVtBQ=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ glib ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postBuild = ''
    install -Dm644 org.Waytrogen.Waytrogen.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
  '';

  postInstall = ''
    install -Dm644 waytrogen.desktop $out/share/applications/waytrogen.desktop
    install -Dm644 README-Assets/WaytrogenLogo.svg $out/share/icons/hicolor/scalable/apps/waytrogen.svg
    while IFS= read -r lang; do
          mkdir -p $out/share/locale/$lang/LC_MESSAGES
          msgfmt locales/$lang/LC_MESSAGES/waytrogen.po -o $out/share/locale/$lang/LC_MESSAGES/waytrogen.mo
    done < locales/LINGUAS
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
    maintainers = with lib.maintainers; [
      genga898
      nikolaizombie1
    ];
    mainProgram = "waytrogen";
    platforms = lib.platforms.linux;
  };
}
