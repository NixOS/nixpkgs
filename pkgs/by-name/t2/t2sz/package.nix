{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "t2sz";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "martinellimarco";
    repo = "t2sz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RX652UNmPJog2n8onkPDD/uXfNASur/dD2F1lPHj1vE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zstd
  ];

  meta = {
    description = "Compress files into seekable zstd, with special handling for tar archives";
    longDescription = ''
      t2sz compresses files into seekable zstd format by splitting them into multiple frames.
      For tar archives, it compresses each file in the archive into an independent frame,
      enabling fast seeking and extraction of individual files without decompressing the entire archive.
    '';
    homepage = "https://github.com/martinellimarco/t2sz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hawkrives ];
    mainProgram = "t2sz";
    platforms = lib.platforms.unix;
  };
})
