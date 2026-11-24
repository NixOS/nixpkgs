{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  stdenv,
  nixosTests,
}:

buildGoModule rec {
  pname = "trickster";
  version = "2.2.2";
  rev = "4595bd6a1ae1165ef497251ad85c646dadc8a925";

  src = fetchFromGitHub {
    owner = "trickstercache";
    repo = "trickster";
    rev = "v${version}";
    sha256 = "sha256-Cq02EJE8bCSVj2iwGREqKUu6zWOm3MxqGKhY195o4s0=";
  };

  vendorHash = "sha256-+mCGkS33zfaKe70lJu4XJSBx/V9GeBjOwYsBY0r9IGQ=";

  subPackages = [ "cmd/trickster" ];

  ldflags = [
    "-extldflags '-static'"
    "-s"
    "-w"
  ]
  ++ (lib.mapAttrsToList (n: v: "-X main.application${n}=${v}") {
    BuildTime = "1970-01-01T00:00:00+0000";
    GitCommitID = rev;
    GoVersion = "go${go.version}}";
    GoArch = "${stdenv.hostPlatform.go.GOARCH}";
  });

  # Tests are broken.
  doCheck = false;

  passthru.tests = { inherit (nixosTests) trickster; };

  meta = {
    description = "Reverse proxy cache and time series dashboard accelerator";
    mainProgram = "trickster";
    longDescription = ''
      Trickster is a fully-featured HTTP Reverse Proxy Cache for HTTP
      applications like static file servers and web APIs.
    '';
    homepage = "https://trickstercache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.linux;
  };
}
