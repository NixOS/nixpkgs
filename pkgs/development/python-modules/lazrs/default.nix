{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "lazrs";
  version = "0.8.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gKMK0XmKn9WOhPI4yiP1ACVVuhZVPir+2vpr3klCKeI=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit pname version;
    hash = "sha256-FmNtH99Ky5ovusbzcvl68MyvtVGUG/pkjBYIVkz0VLc=";
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
