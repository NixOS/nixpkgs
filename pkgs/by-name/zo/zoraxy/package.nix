{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "zoraxy";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TpkDGFmYKKMeU62mcCM0YWtvADdQk7/uP0KkskelnBI=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-yQyq4RrRdIzmx6O19/ogt6zid+7HDTIYvZtpMcQKuqY=";

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
      # Upstream test bug: AccessRuleCreatedEvent gained a `trust_proxy_headers_only`
      # field in 3.3.3 but the test's hardcoded expectedJson was not updated.
      brokenTests = [ "TestEventDeSerialization/AccessRuleCreated" ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" (skippedTests ++ brokenTests)}$" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
