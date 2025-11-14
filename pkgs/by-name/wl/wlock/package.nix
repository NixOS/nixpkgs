{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libxcrypt,
  versionCheckHook,
  nix-update-script,
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

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libxcrypt
  ];

  makeFlags = [
    "PREFIX=$(out)"
    ("WAYLAND_SCANNER=" + lib.getExe wayland-scanner)
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sessionlocker for Wayland compositors that support the ext-session-lock-v1 protocol";
    license = lib.licenses.gpl3Only;
    homepage = "https://codeberg.org/sewn/wlock";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      fliegendewurst
      yiyu
    ];
    mainProgram = "wlock";
  };
})
