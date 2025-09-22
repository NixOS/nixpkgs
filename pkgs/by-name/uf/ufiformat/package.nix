{
  stdenv,
  e2fsprogs,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "ufiformat";
  version = "0.9.9";

  buildInputs = [
    e2fsprogs
  ];

  src = fetchFromGitHub {
    owner = "tedigh";
    repo = "ufiformat";
    rev = "v${version}";
    sha256 = "heFETZj9migz2s9kvmw0ZQ1ieNpU4V4Lwfp91ek2cS4=";
  };

  meta = with lib; {
    homepage = "https://github.com/tedigh/ufiformat";
    description = "Low-level disk formatting utility for USB floppy drives";
    maintainers = [ maintainers.amarshall ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "ufiformat";
  };
}
