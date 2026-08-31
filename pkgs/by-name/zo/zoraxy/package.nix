{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zoraxy";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tnIdmse/aVny0Z/RpIUQPjILNy9M+P9YI1tqm+sQ3a4=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-MG4/5O63019+d/YHSo+WHDIEOGC2QtclPXvEo8Tj7L4=";

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestExtractIssuerNameFromPEM"
        "TestReplaceLocationHost"
        "TestReplaceLocationHostRelative"
        "TestHandleTraceRoute"
        "TestHandlePing"
        "TestListTable"
        "TestWriteAndRead"
        "TestHTTP1p1KeepAlive"
        "TestGetPluginListFromURL"
        "TestUpdateDownloadablePluginList"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "General purpose HTTP reverse proxy and forwarding tool written in Go";
    homepage = "https://zoraxy.arozos.com/";
    changelog = "https://github.com/tobychui/zoraxy/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "zoraxy";
    platforms = lib.platforms.linux;
  };
})
