{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
}:

buildGoModule rec {
  pname = "ugm";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ariasmn";
    repo = "ugm";
    rev = "v${version}";
    hash = "sha256-Co8JN0WEc1I08My9m7iyAshtEO4aszN8/sCvoGFJv2A=";
  };

  vendorHash = "sha256-34D9fQnmKnOyUqshduLmFiVgcVKi7mDKBs3X5ZQxsuw=";

  nativeBuildInputs = [ makeWrapper ];

  # Fix unaligned table when running this program under a CJK environment
  postFixup = ''
    wrapProgram $out/bin/ugm \
        --set RUNEWIDTH_EASTASIAN 0
  '';

  meta = with lib; {
    description = "A terminal based UNIX user and group browser";
    homepage = "https://github.com/ariasmn/ugm";
    changelog = "https://github.com/ariasmn/ugm/releases/tag/${src.rev}";
    license = licenses.mit;
    mainProgram = "ugm";
    platforms = platforms.linux;
    maintainers = with maintainers; [ oo-infty ];
  };
}
