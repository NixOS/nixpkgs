{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "yamlpath-rs";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "yamlpath";
    rev = "refs/tags/v${version}";
    hash = "sha256-5aSXWt4UzQxM93CJxe7P23enh4Zywk8nh0cd5OehLYs=";
  };

  cargoHash = "sha256-w/7teo46xKmEpoeYqD2OAhLBqUIRaXynuCIbaIUCmbo=";

  meta = {
    description = "A library and CLI tool for format-preserving YAML queries";
    changelog = "https://github.com/woodruffw/yamlpath/releases/tag/v${version}";
    homepage = "https://github.com/woodruffw/yamlpath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "yp";
  };
}
