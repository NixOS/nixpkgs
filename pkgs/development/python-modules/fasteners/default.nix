{ stdenv
, buildPythonPackage
, fetchPypi
, six
, monotonic
, testtools
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "063y20kx01ihbz2mziapmjxi2cd0dq48jzg587xdsdp07xvpcz22";
  };

  propagatedBuildInputs = [ six monotonic testtools ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  # Tests are written for Python 3.x only (concurrent.futures)
  doCheck = isPy3k;

  meta = with stdenv.lib; {
    description = "Fasteners";
    homepage = https://github.com/harlowja/fasteners;
    license = licenses.asl20;
  };

}
