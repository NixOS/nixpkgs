{ stdenv, buildPythonPackage, fetchPypi, psutil, docutils }:

buildPythonPackage rec {
  pname = "pynisher";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d82fb94c9ff2ed8f34d1cc9a2c6feb61f794cf931bd33a7f0628896bf450916f";
  };

  propagatedBuildInputs = [ psutil docutils ];

  # no tests in the Pypi archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "The pynisher is a little module intended to limit a functions resources.";
    homepage = "https://github.com/sfalkner/pynisher";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };

}

