{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "lazrs";
  version = "0.7.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UxkbNRwdn6RfdEcWmDhL9CveFFmTCWRfudTDU/D7fyQ=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit pname version;
    hash = "sha256-GVb34eznC5/TA/SpvDq9uJ9M3nUTfx0KyfRFd4WUyCI=";
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
