{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zoraxy";
  version = "3.1.8";
  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    tag = "v${version}";
    hash = "sha256-0BJuomRz/ZnvHQXPZBBrVv1nk2UFPGGdjsZ/FpUAtwk=";
  };

  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-gqDgM+xyvzrpQEQz0fju8GEtQhJOaL6FeuwYxgeSRmo=";

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
