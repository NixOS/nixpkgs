{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  cairo,
  pango,
  pkg-config,
  libadwaita,
  blueprint-compiler,
  wrapGAppsHook4,
  gsettings-desktop-schemas,
  just,
}:

let
  version = "3.2.2";
in
rustPlatform.buildRustPackage {
  pname = "turnon";
  version = version;

  src = fetchFromCodeberg {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-GccO6zwIR/JFdKE3uUQZ3RaBMm9tHumP7jpZRb6n5uU=";
  };

  cargoHash = "sha256-5FBVDNzmen/GnfN6JBmxU4et9gkxZt8RjSD12t/2THI=";

  doCheck = true;

  checkFlags = [
    # Skipped due to "Permission denied (os error 13)"
    "--skip=net::ping::tests::ping_loopback_ipv4"
    "--skip=net::ping::tests::ping_loopback_ipv6"
    "--skip=net::ping::tests::ping_with_timeout_unroutable"
  ];

  nativeBuildInputs = [
    cairo
    pango
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    just
  ];

  buildInputs = [
    libadwaita
    gsettings-desktop-schemas
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace justfile \
        --replace-fail "version := \`git describe --always\`" "version := \"${version}\"" \
        --replace-fail "DESTPREFIX := '/app'" "DESTPREFIX := '$out'" \
        --replace-fail "APPID := 'de.swsnr.turnon.Devel'" "APPID := 'de.swsnr.turnon'" \
        --replace-fail "just --list" "just compile" # Replacing the default recipe with the compile command as just-hook-buildPhase runs the default recipe to compile the package.
    substituteInPlace de.swsnr.turnon.desktop --replace-fail "DBusActivatable=true" "DBusActivatable=false"
  '';

  postBuild = ''
    cargo build --release
  '';

  meta = {
    description = "Turn on devices in your local network";
    homepage = "https://codeberg.org/swsnr/turnon";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ mksafavi ];
    mainProgram = "de.swsnr.turnon";
    platforms = lib.platforms.linux;
  };
}
