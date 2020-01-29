{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.9.3";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6b37344e69020f69fda2b8d97f894cb41fd720840abeda682edd680d1cff838";
  };

  propagatedBuildInputs = [ numpy ];

  # tests not packaged with gsd
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/glotzer/gsd;
    description = "General simulation data file format";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
