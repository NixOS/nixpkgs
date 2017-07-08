{ stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, Keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.3";
  name  = "${pname}-${version}";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "104d58321c5040235b3039ae3215c3c7881073e6aa88bb0b8ca1141ca87c4891";
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
