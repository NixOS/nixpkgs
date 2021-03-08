{ lib, stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0786a916d0572bd9d6afe26e95c6021e3df5dcafa0ece6b302e36366e58c24e";
    extension = "zip";
  };

  meta = with lib; {
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
