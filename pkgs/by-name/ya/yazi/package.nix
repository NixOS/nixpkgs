{ lib
, runCommand
, makeWrapper
, yazi-unwrapped

, withFile ? true
, file
, withJq ? true
, jq
, withPoppler ? true
, poppler_utils
, withUnar ? true
, unar
, withFfmpegthumbnailer ? true
, ffmpegthumbnailer
, withFd ? true
, fd
, withRipgrep ? true
, ripgrep
, withFzf ? true
, fzf
, withZoxide ? true
, zoxide
}:

let
  runtimePaths = with lib; [ ]
    ++ optional withFile file
    ++ optional withJq jq
    ++ optional withPoppler poppler_utils
    ++ optional withUnar unar
    ++ optional withFfmpegthumbnailer ffmpegthumbnailer
    ++ optional withFd fd
    ++ optional withRipgrep ripgrep
    ++ optional withFzf fzf
    ++ optional withZoxide zoxide;
in
runCommand yazi-unwrapped.name
{
  inherit (yazi-unwrapped) pname version meta;

  nativeBuildInputs = [ makeWrapper imagemagick ];
} ''
  mkdir -p $out/bin
  ln -s ${yazi-unwrapped}/share $out/share
  makeWrapper ${yazi-unwrapped}/bin/yazi $out/bin/yazi \
    --prefix PATH : "${lib.makeBinPath runtimePaths}"

  # Resize logo
  for RES in 16 24 32 48 64 128 256; do
    mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
    convert assets/logo.png -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/yazi.png
  done

  mkdir -p $out/share/applications
  install -m644 assets/yazi.desktop $out/share/applications/
''
