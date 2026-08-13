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
  enableResourceMonitor ? true,
  t3code-unwrapped ? callPackage ./unwrapped.nix { },
  t3code-resource-monitor ? callPackage ./resource-monitor.nix { inherit t3code-unwrapped; },
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

  # The resource monitor sidecar is a separate Rust binary that upstream only
  # builds in its electron-builder pipeline, not in `build:desktop`. The server
  # checks this variable before any bundled location, and the desktop app's
  # server child inherits it.
  wrapperArgs =
    lib.optionals (runtimePackages != [ ]) [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath runtimePackages)
    ]
    ++ lib.optionals enableResourceMonitor [
      "--set-default"
      "T3CODE_RESOURCE_MONITOR_PATH"
      (lib.getExe t3code-resource-monitor)
    ];

in
symlinkJoin {
  pname = "t3code";
  inherit (t3code-unwrapped) version;
  __structuredAttrs = true;
  strictDeps = true;

  paths = [ t3code-unwrapped ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = lib.optionalString (wrapperArgs != [ ]) ''
    for program in "$out/bin"/*; do
      wrapProgram "$program" ${lib.escapeShellArgs wrapperArgs}
    done
  '';

  passthru = {
    unwrapped = t3code-unwrapped;
    resourceMonitor = t3code-resource-monitor;
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
