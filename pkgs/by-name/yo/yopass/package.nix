{
  buildGoLatestModule,
  callPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
  nixosTests,
}:
let
  version = "16.2.0";
  src = fetchFromGitHub {
    owner = "jhaals";
    repo = "yopass";
    tag = version;
    hash = "sha256-gdX3jhaOi+DwA2sI7jB19a+NBtRAjC7uDvAb5Li/aNI=";
  };

  website = callPackage ./website.nix { inherit src version; };
in
buildGoLatestModule (finalAttrs: {
  inherit version src;
  pname = "yopass";

  __structuredAttrs = true;

  # go.work only adds deploy/cdk (AWS Lambda deployment); go mod vendor
  # refuses to run in workspace mode.
  env.GOWORK = "off";

  vendorHash = "sha256-7cN47LWlGHSAnhK31O3V9ryetcWczG/fyUVANdhG5VY=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  subPackages = [
    "cmd/yopass"
    "cmd/yopass-server"
  ];

  checkFlags = [
    # Disable tests that require network access
    "-skip=TestSecretNotFoundError"
  ];

  postInstall = ''
    wrapProgram $out/bin/yopass-server \
      --add-flags "--asset-path ${website}"
  '';

  passthru.tests = nixosTests.yopass;

  meta = {
    description = "Secure sharing of secrets, passwords and files";
    homepage = "https://github.com/jhaals/yopass";
    changelog = "https://github.com/jhaals/yopass/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ivarmedi
      fraggerfox
    ];
    mainProgram = "yopass";
    platforms = lib.platforms.unix;
  };
})
