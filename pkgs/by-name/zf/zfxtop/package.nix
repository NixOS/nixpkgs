{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zfxtop";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ssleert";
    repo = "zfxtop";
    rev = finalAttrs.version;
    hash = "sha256-7qeTC9CIx4K2fLRM/pYrSU1NHv9TFMsl7TT0W5Uph60=";
  };

  vendorHash = "sha256-VKBRgDu9xVbZrC5fadkdFjd1OETNwaxgraRnA34ETzE=";

  meta = {
    description = "Fetch top for gen Z with X written by bubbletea enjoyer";
    homepage = "https://github.com/ssleert/zfxtop";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wozeparrot ];
    mainProgram = "zfxtop";
  };
})
