{ mkDerivation, lib, fetchFromGitLab, libarchive, xz, zlib, bzip2, cmake, ninja }:

mkDerivation rec {
  pname = "libarchive-qt";
  version = "2.0.6";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z+2zjQolV1Ncr6v9r7fGrc/fEMt0iMtGwv9eZ2Tu2cA=";
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
