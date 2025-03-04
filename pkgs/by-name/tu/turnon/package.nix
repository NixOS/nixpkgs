{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cairo,
  pango,
  pkg-config,
  libadwaita,
  blueprint-compiler,
  wrapGAppsHook4,
  gsettings-desktop-schemas,
}:

rustPlatform.buildRustPackage rec {
  pname = "turnon";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-eKJRyQMZOa/QRUW0VQ0EkXbJSMcYHfCC9wTs0YEB1yo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SjENjQjdg5Vrpd911QOcH9lmW7+BACaN4a/oGb2miI4=";

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
  ];

  buildInputs = [
    libadwaita
    gsettings-desktop-schemas
  ];

  strictDeps = true;

  postInstall =
    # The build.rs compiles the settings schema and writes the compiled file next to the .xml file.
    # This copies the compiled file to a path that can be detected by gsettings-desktop-schemas
    ''
      mkdir -p "$out/share/glib-2.0/schemas"
      cp "schemas/gschemas.compiled" "$out/share/glib-2.0/schemas"
    '';

  meta = {
    description = "Turn on devices in your local network";
    homepage = "https://github.com/swsnr/turnon";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mksafavi ];
    mainProgram = "turnon";
    platforms = lib.platforms.linux;
  };
}
