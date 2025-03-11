{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ugm";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ariasmn";
    repo = "ugm";
    rev = "v${version}";
    hash = "sha256-FTgu5bzhX+B71dj4wHcgwbtrde5fzF98zMV1lRO++AE=";
  };

  vendorHash = "sha256-Nz9Be2Slfan6FmV9/OxVh7GrLgHBhmt5nOOuXNfjy48=";

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
