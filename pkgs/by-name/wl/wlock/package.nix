{
  lib,
  stdenv,
  fetchFromGitea,
  libxcrypt,
  pkg-config,
  wayland,
  wayland-protocols,
  libxkbcommon,
  wayland-scanner,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wlock";
  version = "1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "wlock";
    tag = finalAttrs.version;
    hash = "sha256-vbGrePrZN+IWwzwoNUzMHmb6k9nQbRLVZmbWIAsYneY=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'chmod 4755' 'chmod 755'
  '';

  buildInputs = [
    libxcrypt
    wayland
    wayland-protocols
    libxkbcommon
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=$(out)"
    ("WAYLAND_SCANNER=" + lib.getExe wayland-scanner)
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  meta = {
    description = "Sessionlocker for Wayland compositors that support the ext-session-lock-v1 protocol";
    license = lib.licenses.gpl3;
    homepage = "https://codeberg.org/sewn/wlock";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fliegendewurst ];
    mainProgram = "wlock";
  };
})
