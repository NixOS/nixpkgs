{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  testers,
  television,
  nix-update-script,
  extraPackages ? [ ],
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "television";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "television";
    tag = finalAttrs.version;
    hash = "sha256-IlFOYnZ9xPQaRheielKqAckyVlSVQMhnO4wCtVixlNQ=";
  };

  cargoHash = "sha256-QKUspbC1bmSeZP0n/O5roEqQkrja+fVKLhAvgzqNS9E=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = lib.optionalString (extraPackages != [ ]) ''
    wrapProgram $out/bin/tv \
      --prefix PATH : ${lib.makeBinPath extraPackages}
  '';

  # TODO(@getchoo): Investigate selectively disabling some tests, or fixing them
  # https://github.com/NixOS/nixpkgs/pull/423662#issuecomment-3156362941
  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = television;
      command = "XDG_DATA_HOME=$TMPDIR tv --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Blazingly fast general purpose fuzzy finder TUI";
    longDescription = ''
      Television is a fast and versatile fuzzy finder TUI.
      It lets you quickly search through any kind of data source (files, git
      repositories, environment variables, docker images, you name it) using a
      fuzzy matching algorithm and is designed to be easily extensible.
    '';
    homepage = "https://github.com/alexpasmantier/television";
    changelog = "https://github.com/alexpasmantier/television/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tv";
    maintainers = with lib.maintainers; [
      louis-thevenet
      getchoo
    ];
  };
})
