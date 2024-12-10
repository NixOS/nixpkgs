{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  imagemagick,
  makeWrapper,
}:
stdenvNoCC.mkDerivation rec {
  pname = "yunfaavatar";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "yunfachi";
    repo = "yunfaAvatar";
    rev = version;
    hash = "sha256-hCpbe+gW9hkiVOKq7a55n5s3bMpyCNGWiY3D2b4VYxg=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/yunfaavatar" \
      --prefix PATH : "${lib.makeBinPath [ imagemagick ]}"
  '';

  meta = with lib; {
    description = "Utility for automatic centralized changing of avatar in Github, Discord, Steam, Shikimori, and many more";
    homepage = "https://github.com/yunfachi/yunfaAvatar";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ yunfachi ];
    mainProgram = "yunfaavatar";
  };
}
