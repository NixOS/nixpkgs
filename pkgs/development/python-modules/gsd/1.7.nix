{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "gsd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fpk69wachyydpk9cbs901m7hkwrrvq24ykxsrz62km9ql8lr2vp";
  };

  propagatedBuildInputs = [ numpy ];

  # tests not packaged with gsd
  doCheck = false;

  meta = with lib; {
    homepage = "https://bitbucket.org/glotzer/gsd";
    description = "General simulation data file format";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
