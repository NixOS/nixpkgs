{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "845a7fe4fd9776cda1bd66112dc2d788cb5ccf8333a205bd4a32807e57d3c875";
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
