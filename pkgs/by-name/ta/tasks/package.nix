{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsecret,
  libxkbcommon,
  openssl,
  pango,
  sqlite,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tasks";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = "tasks";
    rev = "refs/tags/${version}";
    hash = "sha256-0bXzeKnJ5MIl7vCo+7kyXm3L6QrCdm5sPreca1SPi8U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9H4xzjgFpUsY5d6IpFt744058tVvMK0YHYvbnMWxNm8=";

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-07-03";
  env.VERGEN_GIT_SHA = "0e8c728c88a9cac1bac130eb083ca0fe58c7121d";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsecret
    libxkbcommon
    openssl
    pango
    sqlite
    vulkan-loader
    wayland
  ];

  postFixup = ''
    wrapProgram $out/bin/tasks \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          wayland
        ]
      }"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Simple task management application for the COSMIC desktop";
    homepage = "https://github.com/edfloreshz/tasks";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
    mainProgram = "tasks";
  };
}
