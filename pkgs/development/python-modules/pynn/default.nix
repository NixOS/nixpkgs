{ lib
, buildPythonPackage
, fetchFromGitHub
, lazyarray
, jinja2
, docutils
, mock
, numpy
, quantities
, neo
, setuptools
, h5py
, mpi4py
}:

buildPythonPackage rec {
  pname = "pynn";

  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "NeuralEnsemble";
    repo = "PyNN";
    rev = version;
    sha256 = "vsR0TJTX3Z3boq+UHZPd7+vfUZ/kKbWGH7bKzcnMU3Q=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    lazyarray
    jinja2
    docutils
    mock
    numpy
    quantities
    neo
    setuptools
    h5py
    mpi4py
  ];
  meta = with lib; {
    description = "PyNN (pronounced 'pine') is a simulator-independent language for building neuronal network models.";
    homepage = "https://github.com/NeuralEnsemble/PyNN";
    license = with licenses; [ cecill20 ];
    maintainers = with maintainers; [ davidcromp ];
  };
}
