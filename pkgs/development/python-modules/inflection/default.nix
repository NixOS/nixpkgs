{ lib, fetchPypi, buildPythonPackage, isPy27, pytest } :

buildPythonPackage rec {
  pname = "inflection";
  version = "0.4.0";
  disabled = isPy27;

  src = fetchPypi {
   inherit pname version;
   sha256 = "32a5c3341d9583ec319548b9015b7fbdf8c429cbcb575d326c33ae3a0e90d52c";
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

