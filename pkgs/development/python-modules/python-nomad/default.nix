{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ivkfdrmb4wpyawvwrgm3jvx6hn49vqjpwbkmkmamigghqqwacx3";
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
