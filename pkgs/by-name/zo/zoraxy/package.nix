{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zoraxy";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CGSGxiMnWI26t5fD5s74PgrL7nkJXxO3CNCK0ZHpR4I=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-Bl3FI8lodSV5kzHvM8GHbQsep0W8s2BG8IbGf2AahZc=";

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
