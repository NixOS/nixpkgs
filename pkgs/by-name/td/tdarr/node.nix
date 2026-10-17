{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-sUZgyPraowXzPawQcSKAFPDYijdxWr4hAn8I8YGk6X0=";
    linux_arm64 = "sha256-QBMYIBK3x9Getjg+vt8ZH9vLdZaFVSqVrat3RxOGJCw=";
    darwin_arm64 = "sha256-+HM6Hxy97zn5Id20cz13fLlATQLUoUxO/sWVBjV9tq4=";
  };

  includeInPath = [ ccextractor ];
}
