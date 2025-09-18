{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "lazrs";
  version = "0.8.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ij6nRxQO83TJysnLImqg/FuyWYj8ITiiTUFSuoGd044=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit pname version;
    hash = "sha256-9OQKybY6R1yYWgx5cLcRv2pRRWKUhrKH+MoTBuBHH6E=";
  };

  pythonImportsCheck = [ "lazrs" ];

  meta = {
    description = "Python bindings for laz-rs";
    homepage = "https://github.com/laz-rs/laz-rs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nh2
      chpatrick
    ];
    teams = [ lib.teams.geospatial ];
  };
}
