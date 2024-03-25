{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, plank
, intltool
, meson
, ninja
, pkg-config
, vala
, gtk3
, keybinder3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-extras-daemon";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "UbuntuBudgie";
    repo = "budgie-extras";
    rev = "v${finalAttrs.version}";
    hash = "sha256-juPUs5qtY0Sqzh+AxuuWwJL34mL4t/bTbTFmfNg2JrY=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit plank;
    })
  ];

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    keybinder3
  ];

  mesonFlags = [
    (lib.mesonBool "build-recommended" false)
    (lib.mesonBool "with-default-schema" false)
    (lib.mesonBool "build-extrasdaemon" true)
  ];

  strictDeps = true;

  meta = {
    description = "Manages keyboard shortcuts delivered via .bde files for various plugins";
    homepage = "https://github.com/UbuntuBudgie/budgie-extras";
    changelog = "https://github.com/UbuntuBudgie/budgie-extras/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
  };
})
