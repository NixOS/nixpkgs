{ stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, Keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.4";
  name  = "${pname}-${version}";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "10d6d7886235f4b9fa4ba401daef87c27937a04d2763f507643d730e51de37b6";
  };

  # disabled for now due to Tensorflow trying to create files in $HOME:
  doCheck = false;

  propagatedBuildInputs = [ Keras numpy scipy six tensorflow ];

  meta = with stdenv.lib; {
    description = "Probabilistic programming language using Tensorflow";
    homepage = https://github.com/blei-lab/edward;
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
