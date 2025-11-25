{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    tag = "v${version}";
    hash = "sha256-xI9xucRb2D2a1Fvp5DetB4ln3C020qSGEVnuIpy1TMI=";
  };

  vendorHash = "sha256-hieN3RJA0eBqlYxJj6hKgpQhq8s3vg/fPzxW0XSrlPA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  meta = {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    changelog = "https://github.com/vouch/vouch-proxy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      leona
      erictapen
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vouch-proxy";
  };
}
