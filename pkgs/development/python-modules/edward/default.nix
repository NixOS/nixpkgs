{ stdenv, buildPythonPackage, fetchPypi, isPy27, pythonAtLeast
, Keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.1";
  name  = "${pname}-${version}";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f868604c4d13ccc054906fae6c0115edf295a81897cc9dc97026bb083d275ae";
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
