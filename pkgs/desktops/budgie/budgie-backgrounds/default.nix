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
  version = "2.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${version}";
    hash = "sha256-L6y9YVS0NFsycS90AmUJJd9HFMJ/Ge99pI426tC05jA=";
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
    maintainers = [ maintainers.federicoschonborn ];
    license = licenses.cc0;
  };
}
