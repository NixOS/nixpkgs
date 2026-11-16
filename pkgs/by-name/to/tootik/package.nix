{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "tootik";
  version = "0.25.6";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oqpAW+FGuNTS+tazslvawSDG+GrVIapw+3A+TH0yRI8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-twehiGKoLt0h2+TUzPDWbwpk5lZpgXG5SKq+xvLa3/o=";

  subPackages = [ "cmd/tootik" ];

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${finalAttrs.version}" ];

  tags = [ "fts5" ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
})
