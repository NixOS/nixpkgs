{
  lib,
  buildPythonPackage,
  fetchurl,
  stdenv,
}:
buildPythonPackage rec {
  pname = "ffpyplayer";
  version = "4.5.2";
  format = "wheel";

  src = fetchurl {
    url =
      if stdenv.isDarwin then
        "https://github.com/matham/ffpyplayer/releases/download/v${version}/ffpyplayer-${version}-cp313-cp313-macosx_10_13_universal2.whl"
      else
        "https://github.com/matham/ffpyplayer/releases/download/v${version}/ffpyplayer-${version}-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";

    hash =
      if stdenv.isDarwin then
        "sha256-mPvggPi8KbOCuLqHxxHPcvqSt3BGWVgsLlTIFU8mlsU="
      else
        "sha256-+6aibWImMvNe6GNP/JSos0QQJq8NZ7X4v+MwpC4BPFw=";
  };

  meta = with lib; {
    description = "A cython implementation of an ffmpeg based player.";
    homepage = "https://matham.github.io/ffpyplayer/index.html";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ iofq ];
  };
}
