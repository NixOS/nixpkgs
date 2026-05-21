{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libx11,
  libxt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsel";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "kfish";
    repo = "xsel";
    rev = finalAttrs.version;
    hash = "sha256-F2w/Ad8IWxJNH90/0a9+1M8bLfn1M3m4TH3PNpQmEFI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    libx11
    libxt
  ];

  meta = {
    description = "Command-line program for getting and setting the contents of the X selection";
    homepage = "http://www.kfish.org/software/xsel";
    changelog = "https://github.com/kfish/xsel/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = lib.platforms.unix;
    mainProgram = "xsel";
  };
})
