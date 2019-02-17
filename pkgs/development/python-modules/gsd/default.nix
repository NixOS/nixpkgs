{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.5.5";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b80487a8269ba55201390353fd46d1904ec16f5488c8daaf7ff87154e09cca42";
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
