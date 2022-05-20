{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-y7DArNZQwP+2IJmdphHpOq5RBcRqCExM6vL3BO1wjB4=";
  };

  meta = with lib; {
    description = "Utilities for filesystem exploration and automated builds";
    license = licenses.bsd3;
    homepage = "https://github.com/uqfoundation/pox/";
  };

}
