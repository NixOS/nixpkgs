{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "wrtag";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "wrtag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ba3HrAUaI9onuRFns9q2fkJxZWhadqJjd8rAmlIVvg4=";
  };

  vendorHash = "sha256-S0emGAQJi9MLvyU3lL/Vrc4SZ10w6MOqND0LsBI7lg8=";

  # Tests check that cover.PNG does not exist after lowercasing to cover.png,
  # which fails on case-insensitive filesystems (macOS HFS+/APFS default).
  doCheck = stdenv.hostPlatform.isLinux;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion contrib/completions/wrtag.{fish,bash}
    installShellCompletion contrib/completions/metadata.fish
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "wrtag --version";
    };
  };

  meta = {
    description = "Fast automated music tagging and organization based on MusicBrainz";
    longDescription = ''
      wrtag is a music tagging and organisation tool similar to Beets and MusicBrainz Picard.
      Written in go, it aims to be simpler, more composable and faster.
    '';
    homepage = "https://github.com/sentriz/wrtag";
    license = lib.licenses.gpl3Only;
    mainProgram = "wrtag";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
})
