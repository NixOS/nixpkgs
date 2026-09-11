{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "wrtag";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "wrtag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M+HzGCcTWObLwE5W5cSDUTiIy8eCjw+AsIjOIeL9vrQ=";
  };

  vendorHash = "sha256-nXEWwXfX/6Op7P7Aj3B4wzKAWBcPxx7utB5LxePWSVg=";

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
