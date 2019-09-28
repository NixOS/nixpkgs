{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.8.1";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qx3cazz0rllkx9h4vhgl3bp5888c8m1a6w9bwr432ki5p7xp44q";
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
