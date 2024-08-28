{ lib
, stdenv
, fetchFromGitHub
, brotli
, bzip2
, lz4
, xz
, zlib
, zstd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugrep-indexer";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "ugrep-indexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XKjCAYPBRQgId66LupTlODPh2ctzvk7rHWznkLd4C8c=";
  };

  buildInputs = [
    brotli
    bzip2
    lz4
    zlib
    zstd
    xz
  ];

  meta = with lib; {
    description = "Utility that recursively indexes files to speed up recursive grepping";
    homepage = "https://github.com/Genivia/ugrep-indexer";
    changelog = "https://github.com/Genivia/ugrep-indexer/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ mikaelfangel ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
})
