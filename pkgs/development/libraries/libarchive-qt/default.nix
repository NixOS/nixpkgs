{ mkDerivation, lib, fetchFromGitLab, libarchive, xz, zlib, bzip2, cmake, ninja }:

mkDerivation rec {
  pname = "libarchive-qt";
  version = "2.0.4";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-onTV9dgk6Yl9H35EvA6/8vk1IrYH8vg9OQNVgzkt4q4";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libarchive
    bzip2
    zlib
    xz
  ];

  meta = with lib; {
    description = "A Qt based archiving solution with libarchive backend";
    homepage = "https://gitlab.com/marcusbritanicus/libarchive-qt";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
