{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = version;
    hash = "sha256-Vc7ez/W40CefO2ZLAHot14p478pDPtQor865675vCtI=";
  };

  sourceRoot = "${src.name}/mitmproxy-macos";
  pythonImportsCheck = [ "mitmproxy_macos" ];
  nativeBuildInputs = [
    hatchling
  ];

  meta = with lib; {
    description = "The MacOS Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-macos";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ boltzmannrain ];
    platforms = platforms.darwin;
  };
}
