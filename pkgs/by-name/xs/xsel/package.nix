{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libX11,
  libXt,
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
    libX11
    libXt
  ];

  meta = with lib; {
    description = "Command-line program for getting and setting the contents of the X selection";
    homepage = "http://www.kfish.org/software/xsel";
    changelog = "https://github.com/kfish/xsel/releases/tag/${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    platforms = lib.platforms.unix;
    mainProgram = "xsel";
  };
})
