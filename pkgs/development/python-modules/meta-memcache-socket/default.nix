{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

buildPythonPackage rec {
  pname = "meta-memcache-socket";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RevenueCat";
    repo = "meta-memcache-socket-py";
    tag = version;
    hash = "sha256-uPcuzi3fCC8XNJP43ObcSCn5vSgG0V0fx7cDSfQZIQg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-CjzpZGwHbCmIxtVIvpYxzXiRwd2Nr66lXbn2vEI1BgI=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [
    "meta_memcache_socket"
  ];

  meta = {
    description = "Helpers for meta-memcache-py, implemented in rust for improved performance";
    homepage = "https://github.com/RevenueCat/meta-memcache-socket-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ typedrat ];
  };
}
