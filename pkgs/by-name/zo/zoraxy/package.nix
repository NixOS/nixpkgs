{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zoraxy";
  version = "3.1.9";
  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    tag = "v${version}";
    hash = "sha256-zE8ksuZhoi/wPTpo/jq7c5sx0B6hwBr8djvzo9ea9DI=";
  };

  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-XHnDlGIb2K28udWHdkfXt0dPUGmGAjfULB9fykAlsJU=";

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
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "General purpose HTTP reverse proxy and forwarding tool written in Go";
    homepage = "https://zoraxy.arozos.com/";
    changelog = "https://github.com/tobychui/zoraxy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "zoraxy";
    platforms = lib.platforms.linux;
  };
}
