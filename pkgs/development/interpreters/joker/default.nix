{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.12.7";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "0panmhrg1i158xbvqvq3s3217smbj7ynwlaiks18pmss36xx9dk4";
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
