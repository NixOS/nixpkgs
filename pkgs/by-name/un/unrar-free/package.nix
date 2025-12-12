{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  libarchive,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unrar-free";
  version = "0.3.1-unstable-2024-09-19";

  src = fetchFromGitLab {
    owner = "bgermann";
    repo = "unrar-free";
    rev = "a7f9a157276ae68987fb44fe5ccf4f4255eb0a5e";
    hash = "sha256-aCO1vklG5MneEiqS/IBvC09YrvWa+OndfvCblDFKA1E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libarchive ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Free utility to extract files from RAR archives";
    longDescription = ''
      unrar-free is a free software version of the non-free unrar utility.

      This program is a simple command-line front-end to libarchive, and can list
      and extract RAR archives but also other formats supported by libarchive.

      It does not rival the non-free unrar in terms of features, but
      special care has been taken to ensure it meets most user's needs.
    '';
    homepage = "https://gitlab.com/bgermann/unrar-free";
    license = lib.licenses.gpl2Plus;
    mainProgram = "unrar-free";
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
