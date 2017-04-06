{ stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, Keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.2.2";
  name  = "${pname}-${version}";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h9i15l7mczwx8jvabjbvxjjidr13x81h6vylb1p8r308w01r2as";
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
