{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "nsync";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    hash = "sha256-5pd2IpnPB7lEmy44OJjcwfE+yUQBS0fZVG18VUe/3C8=";
  };

  nativeBuildInputs = [ cmake ];

  # Needed for case-insensitive filesystems like on macOS
  # because a file named BUILD exists already.
  cmakeBuildDir = "build_dir";

  meta = {
    homepage = "https://github.com/google/nsync";
    description = "C library that exports various synchronization primitives";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      puffnfresh
      Luflosi
    ];
    platforms = lib.platforms.unix;
  };
}
