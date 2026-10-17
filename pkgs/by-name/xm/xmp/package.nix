{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  alsa-lib,
  libxmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmp";
  version = "4.3.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "xmp-cli";
    tag = "xmp-${finalAttrs.version}";
    hash = "sha256-vy1e/d70c2sMOBEPfAdaPrUQ77BQDJkUNwE9BCFIXeg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libxmp ] ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  meta = {
    description = "Extended module player";
    homepage = "https://xmp.sourceforge.net/";
    changelog = "https://github.com/libxmp/xmp-cli/blob/${finalAttrs.src.rev}/Changelog";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "xmp";
  };
})
