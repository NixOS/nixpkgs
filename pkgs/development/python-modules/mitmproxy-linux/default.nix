{
  lib,
  buildPythonPackage,
  bpf-linker,
  fetchFromGitHub,
  rustPlatform,
  mitmproxy,
}:

buildPythonPackage rec {
  pname = "mitmproxy-linux";
  version = "0.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    tag = "v${version}";
    hash = "sha256-lWUHdS+AkMnIg+1SR+9fC+YjcyLK80UknwGablniLSg=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ihbVh73eulqFyKC49KfsCFJqahr3nWVFFc97iFFf3Nk=";
  };

  buildAndTestSubdir = "mitmproxy-linux";

  nativeBuildInputs = [
    bpf-linker
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "mitmproxy_linux" ];

  meta = with lib; {
    description = "Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-linux";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = licenses.mit;
    inherit (mitmproxy.meta) maintainers;
  };
}
