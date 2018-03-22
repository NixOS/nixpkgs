{ stdenv, fetchPypi, buildPythonPackage, dateutil, pytzdata, tzlocal }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39a255776528afe11ea0d57814f9bf3729c1e0b99063af2e5c6cfd750c3e1f7f";
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
