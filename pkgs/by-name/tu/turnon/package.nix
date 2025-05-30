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
  version = "2.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-MI1qcsPO7Kb7j91nLTmk3dshEpeJuqu6H0k5hrqy4WQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-103EZdoxW+6NWtD7PhEamsOVCeLk+nlGa+LikGn8g+0=";

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

  installPhase = ''
    substituteInPlace Makefile --replace-fail "target/release/turnon" "target/${stdenv.hostPlatform.rust.rustcTarget}/release/turnon"
    make DESTPREFIX=$out install
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
