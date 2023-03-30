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
  version = "0.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${version}";
    hash = "sha256-pDFd+WvWOPgDoSffmX9mzjDQbhePsJV1wGqmPDcnOlw=";
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
