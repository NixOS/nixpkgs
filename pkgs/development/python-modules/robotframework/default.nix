{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab94257cbd848dfca7148e092d233a12853cc7e840ce8231af9cbb5e7f51aa47";
  };

  meta = with stdenv.lib; {
    description = "Generic test automation framework";
    homepage = http://robotframework.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
