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
  version = "0.25.5";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E7ipyOQ1ouEH7N4JTCJgj6vrHm6Ufb4lYdWCBYPHPOE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-imFOJ5IBf0WGLEl+g+F9DmAz6Mmdws9sEETSsvjissw=";

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
