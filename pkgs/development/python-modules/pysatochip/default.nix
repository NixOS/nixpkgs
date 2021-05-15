{ lib, buildPythonPackage, fetchPypi, pyscard, ecdsa, pyaes
, pythonOlder }:

buildPythonPackage rec {
  pname = "pysatochip";
  version = "0.11.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Jj/zZIS9aXmZ2xdi29Eun7iRIrIk9oBlrtN9+6opIMo=";
  };

  propagatedBuildInputs = [ pyscard ecdsa pyaes ];

  pythonImportsCheck = [ "pysatochip" ];

  meta = with lib; {
    description = "Simple python library to communicate with a Satochip hardware wallet";
    homepage = "https://github.com/Toporin/pysatochip";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oxalica ];
  };
}
