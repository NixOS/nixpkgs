{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zoraxy";
  version = "3.0.5";
  src = fetchFromGitHub {
    owner = "tobychui";
    repo = "zoraxy";
    rev = "refs/tags/${version}";
    sha256 = "sha256-bTd6IwzVYxs1xvoy7AdB7WTGfgtHJI+qM3335OWkOEo=";
  };

  sourceRoot = "${src.name}/src";

  vendorHash = "sha256-YI6LSccPDnVhGyPIEFIF41ex0WJlHtb3nP+8+1G/LA0=";

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
    description = "A general purpose HTTP reverse proxy and forwarding tool written in Go";
    homepage = "https://zoraxy.arozos.com/";
    changelog = "https://github.com/tobychui/zoraxy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "zoraxy";
  };
}
