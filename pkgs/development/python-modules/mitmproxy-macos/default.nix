{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  version = "0.11.5";
  format = "wheel";

  src = fetchPypi {
    pname = "mitmproxy_macos";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-j3qqZGrMZLpHkKf01Gy5+/18sEEbm3pWfbBASGS/8o0=";
  };

  # repo has no python tests
  doCheck = false;

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
