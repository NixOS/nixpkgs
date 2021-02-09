{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NH53FaOJx79q5IIYeiz976H9Q8Vnw13qFw4zgRc2TTw=";
  };

  # Upstream hasn't release the tests yet
  doCheck = false;
  pythonImportsCheck = [ "asysocks" ];

  meta = with lib; {
    description = "Python Socks4/5 client and server library";
    homepage = "https://github.com/skelsec/asysocks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
