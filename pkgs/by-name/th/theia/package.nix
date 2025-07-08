{
  ## Helpers to Nix packaging
  lib,
  fetchFromGitHub,

  ## Nix packaging tooling
  buildNpmPackage,

  ## Needed for Executing package.json scripts
  nodejs_22,
  python3,
  electron_36,

  ## Needed for Compiling the native modules
  pkg-config,
  libsecret,
  libX11,
  libxkbfile,
}:

let
  nodejs = nodejs_22;
in

buildNpmPackage (finalAttrs: {
  pname = "theia";
  version = "1.63.2";

  src = fetchFromGitHub {
    owner = "eclipse-theia";
    repo = "theia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XMI+QsxXdrNSU+zJe+lOfYGkTimYiUJszYVE/sKfVHk=";
  };

  npmDepsHash = "sha256-SOMlSKPSItkLkOZe7s5RwJdbLHoqTSZsEOUsjGqDmCg=";
  makeCacheWritable = true;

  env = {
    DEBUG = "electron-rebuild";
    # ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    ## gyp FetchError: web request failed: getaddrinfo EAI_AGAIN
    ## Fix: specify node headers for step `gyp verb get node dir`
    npm_config_nodedir = "${nodejs}";
  };

  # [Long] Description summarised manually from following 3 pages:
  # https://eclipsesource.com/blogs/2018/06/20/welcome-at-eclipse-theia/
  # https://eclipsesource.com/blogs/2024/07/12/vs-code-vs-theia-ide/
  # https://eclipsesource.com/blogs/2023/09/08/eclipse-theia-vs-code-oss/

  meta = {
    description = "Build of Theia Cloud & desktop IDE framework implemented in TypeScript";
    longDescription = ''
      A build of the Eclipse Theia platform (hereafter, Theia) combining
      flexibility with modern web technologies (TypeScript, HTML, CSS).

      Theia is an open source *platform* for building web- and cloud-based
      *custom* IDEs, domain-specific tools & Eclipse RCP-like applications.
      It supports the Language Server Protocol (LSP), the Debug Adapter
      Protocol (DAP), integrates the Monaco Code Editor (component of VS
      Code), and is compatible with VS Code extension API. It allows much
      deeper customization and adaptability using a second extension
      mechanism, called “Theia extension”, that is not limited to a specific
      API as VS Code extensions are.

      Theia is independently developed with a modular architecture and is
      *not a fork of VS Code*. It is governed by the Eclipse Foundation in a
      vendor neutral way, and driven by a diverse set of long-term
      stakeholders, such as Ericsson, STMicroelectronics, Arm,
      EclipseSource, TypeFox and Red Hat.
    '';
    homepage = "https://github.com/eclipse-theia/theia";
    changelog = "https://github.com/eclipse-theia/theia/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      gpl2Only
      epl20
    ];

    # Type of source used to create this package
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ goyalyashpal ];
    mainProgram = "theia";
    platforms = [ "x86_64-linux" ];
  };
})
