{ stdenv, fetchPypi, buildPythonPackage, dateutil, pytzdata, tzlocal }:

buildPythonPackage rec {
  pname = "pendulum";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j6hdsdhhw4d6fy9byr0vyxqnb53ap8bh2a0cibl7p0ks0zvb14j";
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
