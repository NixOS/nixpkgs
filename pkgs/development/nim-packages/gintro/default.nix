{ lib
, nimPackages
, fetchFromGitHub
}:

nimPackages.buildNimPackage rec {
  pname = "gintro";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ParrotSec";
    repo = "gintro";
    rev = version;
    hash = "sha256-RueZtSoZDWzveytD77bV9ZDsVyIAseF4CIuKq4IYeOQ=";
  };

  meta = {
    description = "Nim library for gtk";
    homepage = "https://github.com/ParrotSec/gintro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.all;
  };
}
