{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "0.5.3";
  pname = "wiiload";

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ zlib ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo = "wiiload";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pZdZzCAPfAVucuiV/q/ROY3cz/wxQWep6dCTGNn2fSo=";
  };

  preConfigure = "./autogen.sh";

  meta = {
    description = "Load homebrew apps over network/usbgecko to your Wii";
    mainProgram = "wiiload";
    homepage = "https://wiibrew.org/wiki/Wiiload";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ tomsmeets ];
  };
})
