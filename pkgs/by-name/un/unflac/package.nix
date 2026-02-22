{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ffmpeg,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "unflac";
  version = "1.4";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "unflac";
    rev = finalAttrs.version;
    sha256 = "sha256-1Mpo1eBjfAudl7Lc6DUstEnWlY6G4ZFT9jm9JoWxPlk=";
  };

  vendorHash = "sha256-rq+qfUiR8WJRyoLH/UQVKAorDmrbhHfNYRz6bL4uub4=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/unflac --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
  '';

  meta = {
    description = "Command line tool for fast frame accurate audio image + cue sheet splitting";
    homepage = "https://sr.ht/~ft/unflac/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ felipeqq2 ];
    mainProgram = "unflac";
  };
})
