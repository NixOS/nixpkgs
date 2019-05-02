{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.6.2";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58a6669f2375936810d74c3ee7e62c5616acf9e15aa32603701e55ab6fada5f5";
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
