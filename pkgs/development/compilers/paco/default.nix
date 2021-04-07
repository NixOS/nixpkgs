{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "paco";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pacolang";
    repo = "paco";
    rev = "v${version}";
    sha256 = "03x75h40dhjswbf2g1408krj9b1w05y9pjzygzhklldc75r3n9dh";
  };

  goPackagePath = "github.com/pacolang/paco";
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A simple compiled programming language";
    homepage = "https://github.com/pacolang/paco";
    license = licenses.mit;
    maintainers = with maintainers; [ hugolgst ];
  };
}
