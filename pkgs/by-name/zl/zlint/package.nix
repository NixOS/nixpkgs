{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "zlint";
  version = "3.6.7";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qd6QqOeSfLpXwbni8wqmG5X9zYXDXwAxRotCws4AWsA=";
  };

  modRoot = "v3";

  vendorHash = "sha256-AdJxcJ/qjY6lzoK4PGNjR+7lYAypgCOk6Nt5sqP+ayA=";

  excludedPackages = [
    "cmd/genTestCerts"
    "cmd/gen_test_crl"
    "lints"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "X.509 Certificate Linter focused on Web PKI standards and requirements";
    longDescription = ''
      ZLint is a X.509 certificate linter written in Go that checks for
      consistency with standards (e.g. RFC 5280) and other relevant PKI
      requirements (e.g. CA/Browser Forum Baseline Requirements).
    '';
    homepage = "https://github.com/zmap/zlint";
    changelog = "https://github.com/zmap/zlint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ baloo ];
  };
})
