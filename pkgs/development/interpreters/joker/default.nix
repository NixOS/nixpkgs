{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "joker-${version}";
  version = "0.8.9";

  goPackagePath = "github.com/candid82/joker";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "0ph5f3vc6x1qfh3zn3va2xqx3axv1i2ywbhxayk58p55fxblj5c9";
  };

  preBuild = "go generate ./...";

  dontInstallSrc = true;

  excludedPackages = "gen"; # Do not install private generators.

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/candid82/joker;
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
