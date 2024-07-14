{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy27,
  pytest,
}:

buildPythonPackage rec {
  pname = "inflection";
  version = "0.5.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GilzDTZumWqqz/svHxy5WT3Dji3dMMkSUMbd4J6ptBc=";
  };

  nativeCheckInputs = [ pytest ];
  # Suppress overly verbose output if tests run successfully
  checkPhase = "pytest >/dev/null || pytest";

  meta = {
    homepage = "https://github.com/jpvanhal/inflection";
    description = "Port of Ruby on Rails inflector to Python";
    maintainers = with lib.maintainers; [
      NikolaMandic
      ilya-kolpakov
    ];
    license = lib.licenses.mit;
  };
}
