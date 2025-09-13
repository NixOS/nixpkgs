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
  just,
}:

let
  version = "2.8.2";
in
rustPlatform.buildRustPackage {
  pname = "turnon";
  version = version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-5L7Ewvh1XOPto4shLUFpfOrYWcY4qJQ7ndUI3Yr9T2M=";
  };

  cargoHash = "sha256-Cuv7rJ+/l6vG0hkdMzxVVMpZS8OqM8FCrCl8ypSvyiI=";

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
        --replace-fail "version := \`git describe\`" "version := \"${version}\"" \
        --replace-fail "DESTPREFIX := '/app'" "DESTPREFIX := '$out'" \
        --replace-fail "just --list" "just compile" # Replacing the default recipe with the compile command as just-hook-buildPhase runs the default recipe to compile the package.
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
