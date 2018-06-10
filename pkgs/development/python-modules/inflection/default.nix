{ lib, fetchPypi, buildPythonPackage, pytest } :

buildPythonPackage rec {
  pname = "inflection";
  version = "0.3.1";

  src = fetchPypi {
   inherit pname version;
   sha256 = "1jhnxgnw8y3mbzjssixh6qkc7a3afc4fygajhqrqalnilyvpzshq";
  };

  checkInputs = [ pytest ];
  # Suppress overly verbose output if tests run successfully
  checkPhase = ''pytest >/dev/null || pytest'';

  meta = {
   homepage = https://github.com/jpvanhal/inflection;
   description = "A port of Ruby on Rails inflector to Python";
   maintainers = with lib.maintainers; [ NikolaMandic ilya-kolpakov ];
   license = lib.licenses.mit;
  };
}

