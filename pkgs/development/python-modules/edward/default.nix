{ lib, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.5";
  format = "setuptools";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "3818b39e77c26fc1a37767a74fdd5e7d02877d75ed901ead2f40bd03baaa109f";
  };

  # disabled for now due to Tensorflow trying to create files in $HOME:
  doCheck = false;

  propagatedBuildInputs = [ keras numpy scipy six tensorflow ];

  meta = with lib; {
    description = "Probabilistic programming language using Tensorflow";
    homepage = "https://github.com/blei-lab/edward";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
