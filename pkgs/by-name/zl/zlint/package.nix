{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  zlint,
}:

buildGoModule (finalAttrs: {
  pname = "zlint";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e17cMR2Zlhramv7RG3oriWTDR+UBjXUl+t8lZtqc34Q=";
  };

  modRoot = "v3";

  vendorHash = "sha256-AdJxcJ/qjY6lzoK4PGNjR+7lYAypgCOk6Nt5sqP+ayA=";

  postPatch = ''
    # Remove a package which is not declared in go.mod.
    rm -rf v3/cmd/genTestCerts
    rm -rf v3/cmd/gen_test_crl
  '';

  excludedPackages = [ "lints" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = zlint;
    command = "zlint -version";
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
