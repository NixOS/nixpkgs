{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "nsync";
<<<<<<< HEAD
  version = "1.26.0";
=======
  version = "1.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-pE9waDI+6LQwbyPJ4zROoF93Vt6+SETxxJ/UxeZE5WE=";
=======
    sha256 = "sha256-bdnYrMnBnpnEKGuMlDLILfzgwfu/e5tyMdSDWqreyto=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  # Needed for case-insensitive filesystems like on macOS
  # because a file named BUILD exists already.
  cmakeBuildDir = "build_dir";

  meta = {
    homepage = "https://github.com/google/nsync";
    description = "C library that exports various synchronization primitives";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ puffnfresh Luflosi ];
    platforms = lib.platforms.unix;
  };
}
