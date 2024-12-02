{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  version = "0.9.2";
  format = "wheel";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "mitmproxy_macos";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-Q19gQF6qnoF0TDmeZIxu90A5/ur7N7sDcoeBi2LaNrg=";
  };

  pythonImportsCheck = [ "mitmproxy_macos" ];

  meta = with lib; {
    description = "MacOS Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-macos";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ boltzmannrain ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
