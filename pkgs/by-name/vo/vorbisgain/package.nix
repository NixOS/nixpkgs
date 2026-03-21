{
  lib,
  stdenv,
  fetchurl,
  libogg,
  libvorbis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vorbisgain";
  version = "0.37";

  src = fetchurl {
    url = "https://sjeng.org/ftp/vorbis/vorbisgain-${finalAttrs.version}.tar.gz";
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

  meta = {
    homepage = "https://sjeng.org/vorbisgain.html";
    description = "Utility that corrects the volume of an Ogg Vorbis file to a predefined standardized loudness";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "vorbisgain";
  };
})
