{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-HQ1NaAHY1YRbNUThW983V8x3ptzTc/zNP6yIMyDiq1s=";
  };

  vendorHash = "sha256-1k9YFdackF10iJWJ22XlaENlOfRkZMs+IedDWnd/h8E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  meta = with lib; {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    changelog = "https://github.com/vouch/vouch-proxy/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      leona
      erictapen
    ];
    platforms = platforms.linux;
    mainProgram = "vouch-proxy";
  };
}
