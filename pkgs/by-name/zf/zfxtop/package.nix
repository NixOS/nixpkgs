{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zfxtop";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ssleert";
    repo = "zfxtop";
    rev = version;
    hash = "sha256-7qeTC9CIx4K2fLRM/pYrSU1NHv9TFMsl7TT0W5Uph60=";
  };

  vendorHash = "sha256-VKBRgDu9xVbZrC5fadkdFjd1OETNwaxgraRnA34ETzE=";

  meta = with lib; {
    description = "Fetch top for gen Z with X written by bubbletea enjoyer";
    homepage = "https://github.com/ssleert/zfxtop";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wozeparrot ];
    mainProgram = "zfxtop";
  };
}
