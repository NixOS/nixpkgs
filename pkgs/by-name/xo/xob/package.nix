{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxrender,
  libx11,
  libconfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xob";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "florentc";
    repo = "xob";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PMNjbRAPe43D+bbIRSEsurzhonv52F0Z8mSm5qNTivQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    libxrender
    libconfig
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    # last successful hydra build on darwin was in 2023
    broken = stdenv.hostPlatform.isDarwin;
    description = "Lightweight overlay bar for the X Window System";
    longDescription = ''
      A lightweight configurable overlay volume/backlight/progress/anything bar
      for the X Window System (and Wayland compositors with XWayland). Each
      time a new value is read on the standard input, it is displayed as a
      tv-like bar over other windows. It then vanishes after a configurable
      amount of time. A value followed by a bang '!' is displayed using an
      alternate color to account for special states (e.g. muted audio). There
      is also support for overflows (when the value exceeds the maximum).
    '';
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ florentc ];
    mainProgram = "xob";
  };
})
