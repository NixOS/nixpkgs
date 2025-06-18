{
  lib,
  stdenv,
  fetchFromGitea,
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
  version = "2.7.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-hZA2vkTLvLHSvTlZgXLN52wUVw+r8trHH6urwLrtW/8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fqAGWLk6EWGQcrZYyCF1Aez1+yBg7Qdj1DTAfVwI5FQ=";

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

  postPatch = ''
    substituteInPlace Makefile --replace-fail "target/release/turnon" "target/${stdenv.hostPlatform.rust.rustcTarget}/release/turnon"
  '';

  makeFlags = [
    "DESTPREFIX=${placeholder "out"}"
  ];

  dontCargoInstall = true;

  postInstall =
    # The build.rs compiles the settings schema and writes the compiled file next to the .xml file.
    # This copies the compiled file to a path that can be detected by gsettings-desktop-schemas
    ''
      cp "schemas/gschemas.compiled" "$out/share/glib-2.0/schemas"
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
