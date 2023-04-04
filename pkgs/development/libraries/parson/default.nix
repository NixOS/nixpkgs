{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation {
  pname = "parson";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "kgabis";
    repo = "parson";
    rev = "3c4ee26dbb3df177a2d7b9d80e154ec435ca8c01"; # upstream doesn't use tags
    sha256 = "sha256-fz2yhxy6Q5uEPAbzMxMiaXqSYkQ9uB3A4sV2qYOekJ8=";
  };

  nativeBuildInputs = [ meson ninja ];

  meta = with lib; {
    description = "Lightweight JSON library written in C";
    homepage = "https://github.com/kgabis/parson";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
