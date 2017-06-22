{ stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, Keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.2";
  name  = "${pname}-${version}";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "24aa0bf237965f47dd39d2b2ff43718ba75cb12c471b26ff80a972a66ff32de3";
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
