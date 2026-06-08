{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "lazrs";
  version = "0.8.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K+LUgba6PkgxlQEvenrr7niY6GiKaWRIvzki7wx8L0E=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit pname version;
    hash = "sha256-bMQl1URU4VnRPyw8WdZkZlBv3qldv+vpwd+ZxqPZ/JI=";
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
