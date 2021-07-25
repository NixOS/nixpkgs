{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jrsonnet";
  version = "0.4.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "CertainLach";
    repo = "jrsonnet";
    sha256 = "sha256-OX+iJJ3vdCsWWr8x31psV9Vne6xWDZnJc83NbJqMK1A=";
  };

  postInstall = ''
    ln -s $out/bin/jrsonnet $out/bin/jsonnet
  '';

  cargoSha256 = "sha256-eFfAU9Q3nYAJK+kKP1Y6ONjOIfkuYTlelrFrEW9IJ8c=";

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ lach ];
    license = lib.licenses.mit;
    homepage = "https://github.com/CertainLach/jrsonnet";
  };
}
