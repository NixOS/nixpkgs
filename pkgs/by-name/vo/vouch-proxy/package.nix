{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vouch-proxy";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-orpiVQUJ66SiWISaO5FxrZlfYlD23ffTi0CHoGnRV78=";
  };

  vendorHash = "sha256-aiwIByM619Ps/xNAVeOsII9XKzMguMF3Pi3phgPtneQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  # TestClaimsHMAC requires network access to validate HMAC signatures
  checkFlags = [ "-skip=TestClaimsHMAC" ];

  meta = {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    changelog = "https://github.com/vouch/vouch-proxy/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      leona
      erictapen
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vouch-proxy";
  };
})
