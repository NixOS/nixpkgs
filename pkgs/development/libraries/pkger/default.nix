{ buildGoModule
, fetchFromGitHub
, lib

}:

buildGoModule rec {
  pname = "pkger";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "markbates";
    repo = "pkger";
    rev = "v${version}";
    sha256 = "12zcvsd6bv581wwhahp1wy903495s51lw86b99cfihwmxc5qw6ww";
  };

  vendorSha256 = "1b9gpym6kb4hpdbrixphfh1qylmqr265jrmcd4vxb87ahvrsrvgp";

  doCheck = false;

  meta = with lib; {
    description = "Embed static files in Go binaries (replacement for gobuffalo/packr) ";
    homepage = "https://github.com/markbates/pkger";
    changelog = "https://github.com/markbates/pkger/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
