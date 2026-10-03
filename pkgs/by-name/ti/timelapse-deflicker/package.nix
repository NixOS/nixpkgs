{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timelapse-deflicker";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cyberang3l";
    repo = "timelapse-deflicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wKT9zEGi4V4DK+bi28s/3n6N04qF4ozz+f5m5lu2bi0=";
  };

  installPhase = ''
    install -m755 -D timelapse-deflicker.pl $out/bin/timelapse-deflicker
    wrapProgram $out/bin/timelapse-deflicker --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [
    perl
    ImageMagick
    TermProgressBar
    ImageExifTool
    FileType
    ClassMethodMaker
  ];

  meta = {
    description = "Simple script to deflicker images taken for timelapses";
    mainProgram = "timelapse-deflicker";
    homepage = "https://github.com/cyberang3l/timelapse-deflicker";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ valeriangalliat ];
    platforms = lib.platforms.unix;
  };
})
