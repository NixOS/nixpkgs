{ stdenv, buildPythonPackage, fetchPypi, six, mock }:
buildPythonPackage rec {
  pname = "hiro";
  version = "0.5";
  src = fetchPypi {
    inherit pname version;

    sha256 = "57d9dac63077f24c3d0132c02ac5c71e4bd1d79bdac30dccad4c83fadd49fa1c";
  };

  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Time manipulation utilities for Python";
    homepage = http://hiro.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
