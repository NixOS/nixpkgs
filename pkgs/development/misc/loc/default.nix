{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "0.4.1";
  pname = "loc";

  src = fetchFromGitHub {
    owner = "cgag";
    repo = "loc";
    rev = "v${version}";
    sha256 = "0086asrx48qlmc484pjz5r5znli85q6qgpfbd81gjlzylj7f57gg";
  };

  cargoSha256 = "1qfqhqimp56g34bir30zgl273yssrbmwf1h8h8yvdpzkybpd92gx";

  meta = with lib; {
    homepage = "https://github.com/cgag/loc";
    description = "Count lines of code quickly";
    mainProgram = "loc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = platforms.unix;
  };
}

