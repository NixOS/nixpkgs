{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
}:

buildPythonPackage rec {
  pname = "mitmproxy-macos";
  version = "0.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    rev = version;
    hash = "sha256-V6LUr1jJiTo0+53jipkTyzG5JSw6uHaS6ziyBaFbETw=";
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
