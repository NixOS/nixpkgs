{ lib
, stdenv
, fetchFromGitHub
, imagemagick
, jhead
, meson
, ninja
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-backgrounds";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2E6+WDLIAwqiiPMJw+tLDCT3CnpboH4X0cB87zw/hBQ=";
  };

  nativeBuildInputs = [
    imagemagick
    jhead
    meson
    ninja
  ];

  meta = {
    description = "The default background set for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-backgrounds";
    platforms = lib.platforms.linux;
    maintainers = lib.teams.budgie.members;
    license = lib.licenses.cc0;
  };
})
