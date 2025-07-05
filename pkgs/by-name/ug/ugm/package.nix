{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ugm";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ariasmn";
    repo = "ugm";
    rev = "v${version}";
    hash = "sha256-JgdOoMH8TAUc+23AhU3tZe4SH8GKFeyjSeKm8U7qvpo=";
  };

  vendorHash = "sha256-Dgnh+4bUNyqD8/bj+iUITPB/SBtQPYrB5XC6/M6Zs6k=";

  nativeBuildInputs = [ makeWrapper ];

  # Fix unaligned table when running this program under a CJK environment
  postFixup = ''
    wrapProgram $out/bin/ugm \
        --set RUNEWIDTH_EASTASIAN 0
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Terminal based UNIX user and group browser";
    homepage = "https://github.com/ariasmn/ugm";
    changelog = "https://github.com/ariasmn/ugm/releases/tag/${src.rev}";
    license = licenses.mit;
    mainProgram = "ugm";
    platforms = platforms.linux;
    maintainers = with maintainers; [ oosquare ];
  };
}
