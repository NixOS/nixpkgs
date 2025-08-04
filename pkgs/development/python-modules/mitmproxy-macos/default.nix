{
  lib,
  buildPythonPackage,
  fetchPypi,
  mitmproxy-rs,
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  inherit (mitmproxy-rs) version;
  format = "wheel";

  src = fetchPypi {
    pname = "mitmproxy_macos";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-sNguT3p72v9+FU5XFLYV6p0fO6WvGYerPy68GINwbyA=";
  };

  # repo has no python tests
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy_macos" ];

  meta = {
    description = "MacOS Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-macos";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ boltzmannrain ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
