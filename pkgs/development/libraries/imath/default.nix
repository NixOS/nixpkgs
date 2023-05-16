{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "imath";
<<<<<<< HEAD
  version = "3.1.9";
=======
  version = "3.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "imath";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-NcGiYz7jbxLyVd80lOIyN3zXcC4mHh+dcFEY4Kqw9BY=";
=======
    sha256 = "sha256-8TkrRqQYnp9Ho8jT22EQCEBIjlRWYlOAZSNOnJ5zCM0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Imath is a C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics";
    homepage = "https://github.com/AcademySoftwareFoundation/Imath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
