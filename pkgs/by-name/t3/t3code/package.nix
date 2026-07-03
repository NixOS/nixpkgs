{
  lib,
  callPackage,
  symlinkJoin,
  makeBinaryWrapper,
  enableAzureDevOps ? false,
  azure-cli,
  azure-cli-extensions,
  enableBitbucket ? false,
  bitbucket-cli,
  enableClaude ? false,
  claude-code,
  enableCodex ? true,
  codex,
  enableCursor ? false,
  code-cursor,
  enableCursorCli ? false,
  cursor-cli,
  enableGitHub ? true,
  gh,
  enableGit ? true,
  git,
  enableGitLab ? false,
  glab,
  enableJujutsu ? false,
  jujutsu,
  enableOpencode ? false,
  opencode,
  t3code-unwrapped ? callPackage ./unwrapped.nix { },
}:

let
  runtimePackages =
    lib.optionals enableAzureDevOps [
      (azure-cli.withExtensions [ azure-cli-extensions.azure-devops ])
    ]
    ++ lib.optionals enableBitbucket [ bitbucket-cli ]
    ++ lib.optionals enableClaude [ claude-code ]
    ++ lib.optionals enableCodex [ codex ]
    ++ lib.optionals enableCursor [ code-cursor ]
    ++ lib.optionals enableCursorCli [ cursor-cli ]
    ++ lib.optionals enableGitHub [ gh ]
    ++ lib.optionals enableGit [ git ]
    ++ lib.optionals enableGitLab [ glab ]
    ++ lib.optionals enableJujutsu [ jujutsu ]
    ++ lib.optionals enableOpencode [ opencode ];

in
symlinkJoin {
  pname = "t3code";
  inherit (t3code-unwrapped) version;
  __structuredAttrs = true;
  strictDeps = true;

  paths = [ t3code-unwrapped ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = lib.optionalString (runtimePackages != [ ]) ''
    for program in "$out/bin"/*; do
      wrapProgram "$program" \
        --prefix PATH : "${lib.makeBinPath runtimePackages}"
    done
  '';

  passthru = {
    unwrapped = t3code-unwrapped;
  }
  // t3code-unwrapped.passthru;

  meta = {
    # Manually inherit so that pos works
    inherit (t3code-unwrapped.meta)
      description
      homepage
      downloadPage
      changelog
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
