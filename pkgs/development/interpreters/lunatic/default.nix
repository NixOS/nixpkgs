{ lib, rustPlatform, fetchFromGitHub, cmake, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "lunatic";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "lunatic-solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HqDrGoyYzdx8OTanlRd95L1wAtFeew7Xs2rZ7nK2Zus=";
  };

  cargoSha256 = "sha256-t3EwVYrKx7dvUcSp0B1iUAklg7WdQDld/T0O1HgHw54=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An Erlang inspired runtime for WebAssembly";
    homepage = "https://lunatic.solutions";
    changelog = "https://github.com/lunatic-solutions/lunatic/blob/v${version}/RELEASES.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.isDarwin;
  };
}
