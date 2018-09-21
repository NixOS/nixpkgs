{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ce73a9bc7b79968a2b96cc2b0934e2cbe11700adbd02b4b492fea1e3d4d51f4";
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
