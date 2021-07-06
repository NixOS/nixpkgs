{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jrsonnet";
  version = "0.4.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "CertainLach";
    repo = "jrsonnet";
    sha256 = "sha256-+kvdbUw+lQ/BKJwcBzho1OWg/6y0YDRkLE+SAe8hLQQ=";
  };

  postInstall = ''
    ln -s $out/bin/jrsonnet $out/bin/jsonnet
  '';

  cargoSha256 = "sha256-0soXOxp4Kr1DdmVERl8/sqwltqYLDwkVJZHFnYeHs+c=";

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ lach ];
    license = lib.licenses.mit;
    homepage = "https://github.com/CertainLach/jrsonnet";
  };
}
