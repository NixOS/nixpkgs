{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tootik";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YcpRt17X9EHTCDhyFRnUriin4Y5vllLItKPGbrzUr8Y=";
  };

  proxyVendor = true;
  vendorHash = "sha256-VeMTiOL4JQGzDN4Nan6nZbujDnX2Ksby2W+AK7kAs+M=";

  subPackages = [ "cmd/tootik" ];

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${finalAttrs.version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

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
