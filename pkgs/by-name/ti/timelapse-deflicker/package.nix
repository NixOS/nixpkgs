{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "timelapse-deflicker";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cyberang3l";
    repo = "timelapse-deflicker";
    rev = "v${version}";
    sha256 = "0bbfnrdycrpyz7rqrql5ib9qszny7z5xpqp65c1mxqd2876gv960";
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

<<<<<<< HEAD
  meta = {
    description = "Simple script to deflicker images taken for timelapses";
    mainProgram = "timelapse-deflicker";
    homepage = "https://github.com/cyberang3l/timelapse-deflicker";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ valeriangalliat ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Simple script to deflicker images taken for timelapses";
    mainProgram = "timelapse-deflicker";
    homepage = "https://github.com/cyberang3l/timelapse-deflicker";
    license = licenses.gpl3;
    maintainers = with maintainers; [ valeriangalliat ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
