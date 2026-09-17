{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule (finalAttrs: {
  pname = "vouch-proxy";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xI9xucRb2D2a1Fvp5DetB4ln3C020qSGEVnuIpy1TMI=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-55149.patch";
      url = "https://github.com/vouch/vouch-proxy/commit/fa18ce30ba50a4863a436acad044c22965329c4f.patch";
      hash = "sha256-hhjqt23BIF4ZU1GswRRDnWNbSV0Wa1wpboYRfRyaaco=";
    })
  ];

  vendorHash = "sha256-hieN3RJA0eBqlYxJj6hKgpQhq8s3vg/fPzxW0XSrlPA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

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
