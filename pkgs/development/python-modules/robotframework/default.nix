{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d693e6d06b17f48669e2a8c4cb6c1f0d56e5f1a74835d18b8ea2118da7bf2d79";
    extension = "zip";
  };

  meta = with stdenv.lib; {
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
