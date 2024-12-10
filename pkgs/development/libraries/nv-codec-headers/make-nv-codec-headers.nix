{
  lib,
  stdenvNoCC,
  fetchgit,
}:

{
  pname ? "nv-codec-headers",
  version,
  hash,
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    inherit hash;
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "FFmpeg version of headers for NVENC";
    homepage = "https://ffmpeg.org/";
    downloadPage = "https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
