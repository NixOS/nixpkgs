{ lib, buildPythonPackage, fetchFromGitHub
, pygments }:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.12";

  src = fetchFromGitHub {
     owner = "bitprophet";
     repo = "alabaster";
     rev = "0.7.12";
     sha256 = "1j84iy6bqn73pm3npz25vpyzyqbg3k05zpz7605rylcid59m0hkq";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/bitprophet/alabaster";
    description = "A Sphinx theme";
    license = licenses.bsd3;
  };
}
