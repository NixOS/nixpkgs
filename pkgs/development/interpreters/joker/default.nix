{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "joker";
  version = "0.12.4";

  goPackagePath = "github.com/candid82/joker";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "1swi991khmyhxn6w6xsdqp1wbyx3qmd9d7yhpwvqasyxp8gg3szm";
  };

  preBuild = "go generate ./...";

  postBuild = "rm go/bin/sum256dir";

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
