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
    hash = "sha256-baAfEY4hEN3wOEicgE53gY71IX003JYFyyZaNJ7U8UA=";
  };

  # repo has no python tests
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy_macos" ];

  meta = {
    inherit (mitmproxy-rs.meta) changelog license maintainers;
    description = "MacOS Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-macos";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
