{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  nix-update-script,
  httpx,
  websockets,
  pytestCheckHook,
  pytest-asyncio,
  typeguard,
  gotify-server,
}:

buildPythonPackage rec {
  pname = "gotify";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d-k-bo";
    repo = "python-gotify";
    tag = "v${version}";
    hash = "sha256-epm8m2W+ChOvWHZi2ruAD+HJGj+V7NfhmFLKeeqcpoI=";
  };

  build-system = [ flit-core ];

  dependencies = [
    httpx
    websockets
  ];

  # tests raise an exception if the system is not Linux or Windows
  doCheck = !stdenv.buildPlatform.isDarwin;

  # tests require gotify-server to be located in ./tests/test-server/gotify-linux-{arch}
  postPatch = ''
    ln -s "${gotify-server}/bin/server" ./tests/test-server/gotify-linux-386
    ln -s "${gotify-server}/bin/server" ./tests/test-server/gotify-linux-amd64
    ln -s "${gotify-server}/bin/server" ./tests/test-server/gotify-linux-arm-7
    ln -s "${gotify-server}/bin/server" ./tests/test-server/gotify-linux-arm64
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    typeguard
    gotify-server
  ];

  pythonImportsCheck = [
    "gotify"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/d-k-bo/python-gotify/releases/tag/v${version}";
    description = "Python library to access your gotify server";
    homepage = "https://github.com/d-k-bo/python-gotify";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.joblade
    ];
  };
}
