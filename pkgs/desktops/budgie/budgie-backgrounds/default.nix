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
<<<<<<< HEAD
  version = "2.0";
=======
  version = "1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L6y9YVS0NFsycS90AmUJJd9HFMJ/Ge99pI426tC05jA=";
=======
    hash = "sha256-TdtgOYHO2QH4W2jWBuAzYQwxwAPya2lC3VrIi7kvi+M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    imagemagick
    jhead
    meson
    ninja
  ];

<<<<<<< HEAD
=======
  preConfigure = ''
    chmod +x ./scripts/optimizeImage.sh
    patchShebangs ./scripts/optimizeImage.sh
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "The default background set for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-backgrounds";
    platforms = platforms.linux;
    maintainers = [ maintainers.federicoschonborn ];
    license = licenses.cc0;
  };
}
