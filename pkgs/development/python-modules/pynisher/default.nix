{ stdenv, buildPythonPackage, fetchPypi, psutil, docutils }:

buildPythonPackage rec {
  pname = "pynisher";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sqa3zzqcr4vl5yhnafw1y187z62m4alajggc7dm2riw2ihd9kxl";
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

