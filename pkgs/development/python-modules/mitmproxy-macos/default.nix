{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = "refs/tags/${version}";
    hash = "sha256-nrm1T2yaGVmYsubwNJHPnPDC/A/jYiKVzwBKmuc9MD4=";
  };

  sourceRoot = "${src.name}/mitmproxy-macos";

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [
    "mitmproxy_macos"
  ];

  meta = with lib; {
    description = "The MacOS Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs/tree/main/mitmproxy-macos";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ boltzmannrain ];
    platforms = platforms.darwin;
  };
}
