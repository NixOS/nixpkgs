{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "passerine";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "vrtbl";
    repo = "passerine";
    rev = "30757a528c1656c15ed3403d355d2b9dee028991";
    sha256 = "1vffnl5472gsskq9065cifh4fk52z602sb448ghf1xq9n98drdjf";
  };

  cargoSha256 = "0bd8d5k6d6vwmlsbfkvxx1xbkb9wqihpnmym1lnhk875997hxsq3";

  meta = with lib; {
    description = "A small extensible programming language designed for concise expression with little code";
    homepage = "https://github.com/vrtbl/passerine";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
