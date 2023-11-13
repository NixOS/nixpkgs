{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "nsync";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    hash = "sha256-pE9waDI+6LQwbyPJ4zROoF93Vt6+SETxxJ/UxeZE5WE=";
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
