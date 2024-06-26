{ lib
, buildGoModule
, fetchFromGitLab
, unstableGitUpdater
}:

buildGoModule rec {
  pname = "webtunnel";
  version = "unstable-2023-10-16";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "webtunnel";
    rev = "ae511e2d67297b8b32fdb173549cac7b9f64f45b";
    hash = "sha256-WVNxBg1MNvdAqpms6aHP0WN2/zDRXUaktjH+gf35LZw=";
  };

  vendorHash = "sha256-rL2ju4hmAxEw8hbqrxDnxXFa6BByNBBi9dHLx/okOKk=";

  passthru.updateScript = unstableGitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "Pluggable Transport based on HTTP Upgrade(HTTPT)";
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel";
    maintainers = with maintainers; [ ltstf1re ];
    license = licenses.mit;
  };
}
