{ lib, fetchPypi, buildPythonPackage, isPy27, pytest } :

buildPythonPackage rec {
  pname = "inflection";
  version = "0.5.0";
  disabled = isPy27;

  src = fetchPypi {
   inherit pname version;
   sha256 = "f576e85132d34f5bf7df5183c2c6f94cfb32e528f53065345cf71329ba0b8924";
  };

  checkInputs = [ pytest ];
  # Suppress overly verbose output if tests run successfully
  checkPhase = ''pytest >/dev/null || pytest'';

  meta = {
   homepage = "https://github.com/jpvanhal/inflection";
   description = "A port of Ruby on Rails inflector to Python";
   maintainers = with lib.maintainers; [ NikolaMandic ilya-kolpakov ];
   license = lib.licenses.mit;
  };
}

