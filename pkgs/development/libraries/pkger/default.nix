{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "pkger";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "markbates";
    repo = "pkger";
    rev = "v${version}";
    sha256 = "195ba1avkpm9ssgakngv8j72k7yq2xna3xmm5m8l6c5g7lf91kkp";
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
