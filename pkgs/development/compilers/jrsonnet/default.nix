{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jrsonnet";
  version = "0.3.8";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "CertainLach";
    repo = "jrsonnet";
    sha256 = "sha256-u6P/j7j6S7iPQQh00YFtp2G9Kt4xdWJGsxbuBjvHHZ4=";
  };

  postInstall = ''
    ln -s $out/bin/jrsonnet $out/bin/jsonnet
  '';

  cargoSha256 = "sha256-KGQ3n3BBgLCT3ITIM8p9AxNa62ek4GHymqoD0eQSVKQ=";

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ lach ];
    license = lib.licenses.mit;
    homepage = "https://github.com/CertainLach/jrsonnet";
  };
}
