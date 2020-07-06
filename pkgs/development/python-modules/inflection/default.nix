{ lib, fetchPypi, buildPythonPackage, isPy27, pytest } :

buildPythonPackage rec {
  pname = "inflection";
  version = "0.5.0";
  disabled = isPy27;

  src = fetchPypi {
   inherit pname version;
   sha256 = "09491fx2j4zpbhs6ac7m53jk5yscz73c50sivzvmnkyk698yhxpm";
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

