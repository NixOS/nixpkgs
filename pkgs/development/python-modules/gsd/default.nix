{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.5.4";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p1akwirxq809apxia6b9ndalpdfgv340ssnli78h74bkqnw1376";
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
