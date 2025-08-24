{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "wrtag";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "wrtag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vbe87+iL8Vk9LfuKoI8kyKXsK0n6DVLSzmlOiX070W4=";
  };

  vendorHash = "sha256-X9L0jfjU+fq14ih2uMw2UwEF5Oj+ONzYbtXEEQ3eO50=";

  postInstall = ''
    install -Dm444 contrib/completions/{wrtag,metadata}.fish -t $out/share/fish/vendor_completions.d/
    install -Dm444 contrib/completions/wrtag.bash -T $out/share/bash-completions/completions/wrtag
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
