{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.14.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "1b38alajxs89a9x3f3ldk1nlynp6j90qhl1m2c6561rsm41sqfz0";
  };

  modSha256 = "0i16vf7n1xfz5kp9w3fvyc9y9wgz4h396glgpdaznpxjr12rb43j";

  preBuild = ''
    go generate ./...
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/candid82/joker;
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
