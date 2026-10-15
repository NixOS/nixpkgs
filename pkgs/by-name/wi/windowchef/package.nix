{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  libxrandr,
  libxcb-util,
  libxcb-keysyms,
  libxcb-wm,
  xcbproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "windowchef";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "tudurom";
    repo = "windowchef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F/rniW65wOeUC0l2VupJbVzdUx8QZiNkpkg4wY+nm9Q=";
  };

  buildInputs = [
    libxcb
    libxrandr
    libxcb-util
    libxcb-keysyms
    libxcb-wm
    xcbproto
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Stacking window manager that cooks windows with orders from the Waitron";
    homepage = "https://github.com/tudurom/windowchef";
    maintainers = with lib.maintainers; [ bhougland ];
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
  };
})
