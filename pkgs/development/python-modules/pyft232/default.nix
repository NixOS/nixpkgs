{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyusb
}:

buildPythonPackage rec {
  pname = "pyft232";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "lsgunth";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-t9CKTZCUro9Fn7k3WwCZVoH8VS3KZrpu9WSXEN6sPl0=";
  };

  propagatedBuildInputs = [
    pyserial
    pyusb
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python bindings to d2xx and libftdi to access FT232 chips with the same interface as pyserial";
    homepage = "https://github.com/lsgunth/pyft232";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ fsagbuya ];
  };
}
