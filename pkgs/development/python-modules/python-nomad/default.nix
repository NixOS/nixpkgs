{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rf6ad35vg3yi1p4l383xwx0ammdvr1k71bxg93bgcvljypx4cyn";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require nomad agent
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python client library for Hashicorp Nomad";
    homepage = "https://github.com/jrxFive/python-nomad";
    license = licenses.mit;
    maintainers = with maintainers; [ xbreak ];
  };
}
