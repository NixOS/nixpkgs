{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
<<<<<<< HEAD
    sha256 = "sha256-D9maTCNNJ9ivj76SEjddFSYNu+RLEZG+3SgOWEAD7aU=";
  };

  vendorHash = "sha256-ioC7R5Pm2nmHXI+/ko1UoNJCvEFzvhZcAcVtaFECz2c=";
=======
    sha256 = "sha256-ERkK4T+nUTf18OoEctSugeK4i/f6k0naBKxzn+6pe38=";
  };

  vendorSha256 = "sha256-AYoespfzFLP/jIIxbw5K653wc7sSfLY8K7di8GZ64wA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/candid82/joker";
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
