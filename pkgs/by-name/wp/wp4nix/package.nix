{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix,
  subversion,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "wp4nix";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "git.helsinki.tools";
    owner = "helsinki-systems";
    repo = "wp4nix";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WJteeFUMr684yZEtUP13MqRjJ1UAeo48AzOPdLEE65w=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/wp4nix \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          subversion
        ]
      }
  '';

  meta = {
    description = "Packaging helper for Wordpress themes and plugins";
    mainProgram = "wp4nix";
    homepage = "https://git.helsinki.tools/helsinki-systems/wp4nix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.unix;
  };
})
