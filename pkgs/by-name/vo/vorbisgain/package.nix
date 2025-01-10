{
  lib,
  stdenv,
  fetchurl,
  libogg,
  libvorbis,
}:

stdenv.mkDerivation rec {
  pname = "vorbisgain";
  version = "0.37";

  src = fetchurl {
    url = "https://sjeng.org/ftp/vorbis/vorbisgain-${version}.tar.gz";
    sha256 = "1v1h6mhnckmvvn7345hzi9abn5z282g4lyyl4nnbqwnrr98v0vfx";
  };

  patches = [
    ./isatty.patch
    ./fprintf.patch
  ];

  buildInputs = [
    libogg
    libvorbis
  ];

  meta = with lib; {
    homepage = "https://sjeng.org/vorbisgain.html";
    description = "Utility that corrects the volume of an Ogg Vorbis file to a predefined standardized loudness";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "vorbisgain";
  };
}
