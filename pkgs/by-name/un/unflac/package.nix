{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ffmpeg,
  makeWrapper,
}:

buildGoModule rec {
  pname = "unflac";
  version = "1.3";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "unflac";
    rev = version;
    sha256 = "sha256-xJEVrzooNcS3zEKeF6DB7ZRZEjHfC7dGKgQfswxbD+U=";
  };

  vendorHash = "sha256-IQHxEYv6l8ORoX+a3Szox9tS2fyBk0tpK+Q1AsWohX0=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/unflac --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
  '';

  meta = with lib; {
    description = "Command line tool for fast frame accurate audio image + cue sheet splitting";
    homepage = "https://sr.ht/~ft/unflac/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ felipeqq2 ];
    mainProgram = "unflac";
  };
}
