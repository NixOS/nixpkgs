{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "91259775f43ca589d8a846e3add881fe59818f82";
    hash = "sha256-r+AQbW8VEh+3/NVSgroX0VT7gFLaEMSZpS90+Wp+MnU=";
  };

  vendorHash = "sha256-B45Q9G+p/idqqz45lLQQuDGLwAzhKuo9Ev+cISGbKUo=";

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    export HOME=`mktemp -d`
    git config --global --replace-all protocol.file.allow always
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Fast trigram based code search";
    homepage = "https://github.com/sourcegraph/zoekt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "zoekt";
  };
}
