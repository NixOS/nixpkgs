{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18icw5cbsq4gnhx4vsjwhxzcx11mbnz6kmwgrylkf82m7m1v2921";
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
