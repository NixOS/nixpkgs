{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terrapin-scanner";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "RUB-NDS";
    repo = "Terrapin-Scanner";
    rev = "v${version}";
    hash = "sha256-fn5qtv6pOvk62K6C7ZQBNOU7JwwnNU0G9Ak19M1nB0A=";
  };

  vendorHash = null;

  meta = {
    description = "Simple vulnerability scanner for the Terrapin attack";
    homepage = "https://github.com/RUB-NDS/Terrapin-Scanner";
    changelog = "https://github.com/RUB-NDS/Terrapin-Scanner/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "Terrapin-Scanner";
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
