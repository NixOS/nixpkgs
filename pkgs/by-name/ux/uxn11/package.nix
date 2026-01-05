{
  lib,
  stdenv,
  fetchFromSourcehut,
  xorg,
}:

stdenv.mkDerivation {
  pname = "uxn11";
  version = "1.0-unstable-2025-09-27";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn11";
    rev = "3c16d2acecfe4784dfe75de520e6229fa809b634";
    hash = "sha256-NKFaj/7V8S+W7c5v4uzPT9hpNHAmP/J7LGR6/0lQ3ds=";
  };

  buildInputs = [
    xorg.libX11
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~rabbits/uxn11";
    description = "X11 and standalone text-mode emulators for the Uxn virtual machine";
    license = lib.licenses.mit;
    mainProgram = "uxn11";
    maintainers = with lib.maintainers; [ jleightcap ];
    inherit (xorg.libX11.meta) platforms;
  };
}
