{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  docutils,
  pkg-config,
  glib,
  libpthread-stubs,
  libxau,
  libxdmcp,
  libxcb-util,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xss-lock";
  version = "0.4.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wavexx";
    repo = "xss-lock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AtaNuEZhFpw9uimQkuMorBbTkE0J4h9fjV7ZEjz8mgg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    docutils
  ];
  buildInputs = [
    glib
    libpthread-stubs
    libxau
    libxdmcp
    libxcb-util
  ];

  passthru.tests = { inherit (nixosTests) xss-lock; };

  meta = {
    description = "Use external locker (such as i3lock) as X screen saver";
    homepage = "https://github.com/wavexx/xss-lock";
    license = lib.licenses.mit;
    mainProgram = "xss-lock";
    maintainers = with lib.maintainers; [
      malyn
      coolcuber
    ];
    platforms = lib.platforms.linux;
  };
})
