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
  version = "1.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${version}";
    hash = "sha256-TdtgOYHO2QH4W2jWBuAzYQwxwAPya2lC3VrIi7kvi+M=";
  };

  nativeBuildInputs = [
    imagemagick
    jhead
    meson
    ninja
  ];

  preConfigure = ''
    chmod +x ./scripts/optimizeImage.sh
    patchShebangs ./scripts/optimizeImage.sh
  '';

  meta = with lib; {
    description = "The default background set for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-backgrounds";
    platforms = platforms.linux;
    maintainers = [ maintainers.federicoschonborn ];
    license = licenses.cc0;
  };
}
