{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jrsonnet";
  version = "0.4.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "CertainLach";
    repo = "jrsonnet";
    sha256 = "sha256-vDZpb5Z8XOVc6EJ1Nul07kC8ppqcGzKPb4DEarqq2yg=";
  };

  postInstall = ''
    ln -s $out/bin/jrsonnet $out/bin/jsonnet
  '';

  cargoSha256 = "sha256-SR3m2meW8mTaxiYgeY/m7HFPrHGVtium/VRU6vWKxys=";

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ lach ];
    license = lib.licenses.mit;
    homepage = "https://github.com/CertainLach/jrsonnet";
  };
}
