{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "nsync";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    sha256 = "sha256-jQJtlBDR6efBe1tFOUOZ6awaMTT33qM/GbvbwiWTZxw=";
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
