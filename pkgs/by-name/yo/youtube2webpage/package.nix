{ lib
, stdenv
, perl
, fetchFromGitHub
, yt-dlp
, ffmpeg
, makeWrapper
}:

let
  mainProgram = "yt-to-webpage.pl";
  src = fetchFromGitHub {
    owner = "obra";
    repo = "Youtube2Webpage";
    rev = "d39458fafc35ed288699a3bf65321eaacb46f4cc";
    hash = "sha256-u+bMY2J/IpvMrBhZzv1MN0LDaomD7qGy3RoiNEFo6Ow=";
  };
in

stdenv.mkDerivation {
  pname = "youtube2webpage";
  version = "unstable-2023-11-09";
  inherit src;

  dontBuild = true;

  # add a line to the script that copies styles.css into the output
  postPatch = ''
    substituteInPlace ${mainProgram} \
      --replace \
        'mkdir($slug);' \
        'mkdir($slug); use File::Copy; copy("'$out'/styles.css", $slug);'
    patchShebangs ${mainProgram}
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    perl
    ffmpeg
    yt-dlp
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv ${mainProgram} $out/bin/
    chmod +x $out/bin/${mainProgram}
    cp ${src}/styles.css $out
    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/${mainProgram} --prefix PATH ":" ${ffmpeg}/bin:${yt-dlp}/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/obra/Youtube2Webpage";
    description = "Turns a youtube video into a webpage with screenshots and subtitles.";
    license = lib.licenses.mit;
    inherit mainProgram;
  };
}
