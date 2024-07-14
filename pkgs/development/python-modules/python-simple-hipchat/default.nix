{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-simple-hipchat";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W70cdJQgrIT3Ys657uA3MyBJEkTPvV47YVIWJHO+xn8=";
  };

  meta = with lib; {
    description = "Easy peasy wrapper for HipChat's v1 API";
    homepage = "https://github.com/kurttheviking/simple-hipchat-py";
    license = licenses.mit;
  };
}
