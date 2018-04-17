{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "configobj";
  version = "5.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00h9rcmws03xvdlfni11yb60bz3kxfvsj6dg6nrpzj71f03nbxd2";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Config file reading, writing and validation";
    homepage = https://pypi.python.org/pypi/configobj;
    license = licenses.bsd3;
    maintainers = with maintainers; [ garbas ];
  };
}
