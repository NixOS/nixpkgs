{ lib, fetchFromGitHub, buildPythonPackage, isPy27, pytest } :

buildPythonPackage rec {
  pname = "inflection";
  version = "0.5.1";
  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "jpvanhal";
     repo = "inflection";
     rev = "0.5.1";
     sha256 = "0mvs6wgpi963k7mqrwzdkh32m29zcm772q0fy7pwszlcsh3l50kg";
  };

  checkInputs = [ pytest ];
  # Suppress overly verbose output if tests run successfully
  checkPhase = "pytest >/dev/null || pytest";

  meta = {
   homepage = "https://github.com/jpvanhal/inflection";
   description = "A port of Ruby on Rails inflector to Python";
   maintainers = with lib.maintainers; [ NikolaMandic ilya-kolpakov ];
   license = lib.licenses.mit;
  };
}

