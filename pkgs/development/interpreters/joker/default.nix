{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.14.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "1wi80sr8h9fwh4xipff0y6qdzrliwyk2w1bmi33ncykxd9r2g7nk";
  };

  modSha256 = "0i16vf7n1xfz5kp9w3fvyc9y9wgz4h396glgpdaznpxjr12rb43j";

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/candid82/joker";
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
