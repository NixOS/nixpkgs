{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vouch-proxy";
  version = "0.47.2";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BdqdJosX1Z1CsPDW65ybk6oGdSk/RXHPaEJuuIedNJ4=";
  };

  vendorHash = "sha256-Ma5/S2PXQ9lByIpIfkkLeiw/9rvmasSMElE1VoGIEHc=";

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
