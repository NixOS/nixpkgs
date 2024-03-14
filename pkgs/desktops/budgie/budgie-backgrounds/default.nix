{ lib
, stdenv
, fetchFromGitHub
, imagemagick
, jhead
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "budgie-backgrounds";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${version}";
    hash = "sha256-2E6+WDLIAwqiiPMJw+tLDCT3CnpboH4X0cB87zw/hBQ=";
  };

  nativeBuildInputs = [
    imagemagick
    jhead
    meson
    ninja
  ];

  meta = with lib; {
    description = "The default background set for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-backgrounds";
    platforms = platforms.linux;
    maintainers = teams.budgie.members;
    license = licenses.cc0;
  };
}
