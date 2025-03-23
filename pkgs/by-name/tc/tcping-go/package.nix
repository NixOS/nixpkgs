{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule {
  pname = "tcping-go";
  version = "unstable-2022-05-28";

  src = fetchFromGitHub {
    owner = "cloverstd";
    repo = "tcping";
    rev = "83f644c761819f7c4386f0645cd0a337eccfc62e";
    sha256 = "sha256-GSkNfaGMJbBqDg8DKhDtLAuUg1yF3FbBdxcf4oG50rI=";
  };

  vendorHash = "sha256-Q+aFgi7GCAn3AxDuGtRG4DdPhI7gQKEo7A9iu1YcTsQ=";

  meta = with lib; {
    description = "Ping over TCP instead of ICMP, written in Go";
    homepage = "https://github.com/cloverstd/tcping";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "tcping";
  };
}
