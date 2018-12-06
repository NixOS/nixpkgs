{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "4.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab235d9fe64833f12d1334d29b558aacedfbca2356dfb9691f2d0d38a8a7bfb4";
  };

  # No tests in archive
  doCheck = false;
  checkInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = http://nedbatchelder.com/code/coverage/;
    license = lib.licenses.bsd3;
  };
}