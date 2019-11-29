{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.12.9";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "19n2pzs045mflyzgq3cpa4w2fbd0f77j5k6c4yc3gk0mcwgdxhs2";
  };

  modSha256 = "0i16vf7n1xfz5kp9w3fvyc9y9wgz4h396glgpdaznpxjr12rb43j";

  meta = with stdenv.lib; {
    homepage = https://github.com/candid82/joker;
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
