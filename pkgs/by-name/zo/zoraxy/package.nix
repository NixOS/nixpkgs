{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zoraxy";
  version = "3.2.9";

  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rNUjbIG63SFI9EkDq9HfuKhjizyjSOPq0YXg7L6VLtQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-KmyCtx4PyVOFGNHVg08u10zypC1oosIW8dOiQpt9IUU=";

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
