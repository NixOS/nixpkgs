{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "joker-${version}";
  version = "0.9.4";

  goPackagePath = "github.com/candid82/joker";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "15q9w93yjc5zl9z45mkcfizgz5r3mzbkah0ng0hdxf0qqy6b09w8";
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
