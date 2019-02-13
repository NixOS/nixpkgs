{ stdenv, buildPythonPackage, fetchPypi, psutil, docutils }:

buildPythonPackage rec {
  pname = "pynisher";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b1079315ad1009de108c9ad701f6ae5274264e64503fc22c2de366d99953f34";
  };

  propagatedBuildInputs = [ psutil docutils ];

  # no tests in the Pypi archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "The pynisher is a little module intended to limit a functions resources.";
    homepage = https://github.com/sfalkner/pynisher;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };

}

