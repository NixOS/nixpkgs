{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "joker-${version}";
  version = "0.9.5";

  goPackagePath = "github.com/candid82/joker";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "1sgxz0z6p92k1rhs5095l952a2db5w9yb2jy6cgglxw2arihxxb7";
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
