{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.15.7";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "01mlizkflajad4759yl60ymibymrvanhc22jaffj50k9b77v97kq";
  };

  vendorSha256 = "031ban30kx84r54fj9aq96pwkz9nqh4p9yzs4l8i1wqmy52rldvl";

  doCheck = false;

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/candid82/joker";
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
