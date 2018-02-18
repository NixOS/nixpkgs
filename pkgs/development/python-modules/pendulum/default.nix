{ stdenv, fetchPypi, buildPythonPackage, dateutil, pytzdata, tzlocal }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f16fb759e6126dd89d49886f8100caa72e5ab36563bc148b4f7eddfa0099c0f";
  };

  propagatedBuildInputs = [ dateutil pytzdata tzlocal ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python datetimes made easy";
    homepage = https://github.com/sdispater/pendulum;
    license = licenses.mit;
  };
}
