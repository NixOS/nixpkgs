{ stdenv, buildPythonPackage, fetchPypi, isPy36 }:

buildPythonPackage rec {
  pname = "dataclasses";
  version = "0.6";

  # backport only works on Python 3.6, and is in the standard library in Python 3.7
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6988bd2b895eef432d562370bb707d540f32f7360ab13da45340101bc2307d84";
  };

  meta = with stdenv.lib; {
    description = "An implementation of PEP 557: Data Classes";
    homepage = "https://github.com/ericvsmith/dataclasses";
    license = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
