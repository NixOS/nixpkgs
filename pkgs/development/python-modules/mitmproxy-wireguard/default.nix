{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "mitmproxy-wireguard";
  version = "0.1.17";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "decathorpe";
    repo = "mitmproxy_wireguard";
    rev = "refs/tags/${version}";
    hash = "sha256-G//3h9QHModKNcGqG2FcV65bver809J4Xnig/Fr5zdg=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-KPk6lLofsWDG+rswG5+q4bs9CZJFn4RuepX/OQvZ1Pw=";
  };

  # Module has no tests, only a test client
  doCheck = false;

  pythonImportsCheck = [
    "mitmproxy_wireguard"
  ];

  meta = with lib; {
    description = "WireGuard frontend for mitmproxy";
    homepage = "https://github.com/decathorpe/mitmproxy_wireguard";
    changelog = "https://github.com/decathorpe/mitmproxy_wireguard/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
