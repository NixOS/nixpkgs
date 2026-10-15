{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  stockfish,
}:

buildGoModule (finalAttrs: {
  pname = "uchess";
  version = "0.2.1";

  subPackages = [ "cmd/uchess" ];

  src = fetchFromGitHub {
    owner = "tmountain";
    repo = "uchess";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vxoyGyoAMLBk1N3gUkUlsP6zxL57/jCIvA3qF4gbVNo=";
  };

  vendorHash = "sha256-4yEE1AsSChayCBxaMXPsbls7xGmFeWRhfOMHyAAReDY=";

  # package does not contain any tests as of v0.2.1
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uchess --suffix PATH : ${stockfish}/bin
  '';

  meta = {
    description = "Play chess against UCI engines in your terminal";
    mainProgram = "uchess";
    homepage = "https://tmountain.github.io/uchess/";
    maintainers = with lib.maintainers; [ tmountain ];
    license = lib.licenses.mit;
  };
})
