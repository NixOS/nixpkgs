{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
}:

buildPythonPackage rec {
  pname = "lazyarray";

  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "NeuralEnsemble";
    repo = "lazyarray";
    rev = "9d60f2c";
    sha256 = "D4KzICEdCoA1S8uKRU76Q6PfcolbuZsLAtDIm4a94wo=";
  };

  # Test based on py2
  doCheck = false;

  propagatedBuildInputs = [
    numpy
  ];
  meta = with lib; {
    description = "lazyarray is a Python package that provides a lazily-evaluated numerical array class, larray, based on and compatible with NumPy arrays.";
    homepage = "https://github.com/NeuralEnsemble/lazyarray";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ davidcromp ];
  };
}
