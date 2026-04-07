{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  maturin,
}:

buildPythonPackage rec {
  pname = "davey";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Snazzah";
    repo = "davey";
    tag = "py-${version}";
    hash = "sha256-WR8OBYZXNxFfToVn0ZNkacZPN04w/y3tCK6/xCP50gI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kLLOuwGCfkByXt6LW8vGxS1JYQW+r/tW7dOiKx6M4k4=";
  };

  nativeBuildInputs = [
    maturin
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  format = "pyproject";

  maturinBuildFlags = [
    "--manifest-path"
    "davey-python/Cargo.toml"
  ];

  pythonImportsCheck = [ "davey" ];

  meta = {
    description = "A Discord Audio & Video End-to-End Encryption (DAVE) Protocol Rust implementation";
    homepage = "https://github.com/Snazzah/davey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twig ];
  };
}
