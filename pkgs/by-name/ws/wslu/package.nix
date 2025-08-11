{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wslu";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = "wslu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ssiwYkQg2rOirC/ZZVq2bJm4Ggc364uRkoS2y365Eb0=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  patches = [
    ./fallback-conf-nix-store.diff
  ];

  postPatch = ''
    substituteInPlace src/wslu-header \
      --subst-var out
    substituteInPlace src/etc/wslview.desktop \
      --replace-fail /usr/bin/wslview wslview
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    description = "Collection of utilities for Windows Subsystem for Linux";
    homepage = "https://github.com/wslutilities/wslu";
    changelog = "https://github.com/wslutilities/wslu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jamiemagee ];
    platforms = lib.platforms.linux;
  };
})
