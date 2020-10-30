{ lib, fetchPypi, buildPythonPackage, isPy27, pytest } :

buildPythonPackage rec {
  pname = "inflection";
  version = "0.5.1";
  disabled = isPy27;

  src = fetchPypi {
   inherit pname version;
   sha256 = "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417";
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

