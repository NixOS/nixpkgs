{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "pkger";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "markbates";
    repo = "pkger";
    rev = "v${version}";
    sha256 = "0fpvrgww5h40l2js7raarx6gpysafvj75x26ljx4qz925x8nb6zn";
  };

  vendorSha256 = "1b9gpym6kb4hpdbrixphfh1qylmqr265jrmcd4vxb87ahvrsrvgp";

  meta = with stdenv.lib; {
    description = "Embed static files in Go binaries (replacement for gobuffalo/packr) ";
    homepage = "https://github.com/markbates/pkger";
    changelog = "https://github.com/markbates/pkger/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
