{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, glib
, gtk3
, intltool
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop-view";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop-view";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-k6VfAGWvUarhBFnREasOvWH3M9uuT5SFUpMFmKo1fmE=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    intltool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [ (lib.mesonBool "werror" false) ];

  meta = {
    description = "Official Budgie desktop icons application/implementation";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop-view";
    mainProgram = "org.buddiesofbudgie.budgie-desktop-view";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.budgie.members;
  };
})
