{
  lib,
  stdenv,
  libxrandr,
  libxi,
  libxext,
  libx11,
  pkg-config,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xplugd";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "xplugd";
    rev = "v${finalAttrs.version}";
    sha256 = "11vjr69prrs4ir9c267zwq4g9liipzrqi0kmw1zg95dbn7r7zmql";
  };

  buildInputs = [
    libx11
    libxi
    libxrandr
    libxext
  ];
  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    homepage = "https://github.com/troglobit/xplugd";
    description = "UNIX daemon that executes a script on X input and RandR changes";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ akho ];
    mainProgram = "xplugd";
  };
})
