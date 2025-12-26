{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  libX11,
  libXext,
  libXft,
  ncurses,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xst";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gnotclub";
    repo = "xst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2pXR9U2tTBd0lyeQ3BjnXW+Ne9aUQg/+rnpmYPPG06A=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libX11
    libXext
    libXft
    ncurses
  ];

  installFlags = [
    "TERMINFO=$(out)/share/terminfo"
    "PREFIX=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/gnotclub/xst";
    description = "Simple terminal fork that can load config from Xresources";
    mainProgram = "xst";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
