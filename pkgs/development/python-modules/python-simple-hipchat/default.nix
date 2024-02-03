{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-simple-hipchat";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zy6prrj85jjc4xmxgfg8h94j81k6zhfxfffcbvq9b10jis1rgav";
  };

  meta = with lib; {
    description = "Easy peasy wrapper for HipChat's v1 API";
    homepage = "https://github.com/kurttheviking/simple-hipchat-py";
    license = licenses.mit;
  };
}
