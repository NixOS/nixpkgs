{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zoraxy";
  version = "3.1.1";
  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    rev = "refs/tags/${version}";
    hash = "sha256-ZjsBGtY6M5jIXylzg4k8U4krwqx5d5VuMiVHAeUIbXY=";
  };

  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-p2nczUMT3FfYX32yvbR0H5FyHV2v9I18yvn0lwUwy+A=";

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestExtractIssuerNameFromPEM"
        "TestReplaceLocationHost"
        "TestReplaceLocationHostRelative"
        "TestHandleTraceRoute"
        "TestHandlePing"
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
