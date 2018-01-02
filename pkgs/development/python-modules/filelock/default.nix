{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "2.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n67dw7np5gsy5whynyk8c46pjlr353d6j9735p5gryaszkpjl6h";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
