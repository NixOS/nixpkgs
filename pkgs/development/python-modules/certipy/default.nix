{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyopenssl,
}:

buildPythonPackage rec {
  pname = "certipy";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aVcEt3FrAzN1yaEyTQ0w8nEQooiVxAFRqQ7Af/EDKFk=";
  };

  propagatedBuildInputs = [ pyopenssl ];

  doCheck = false; # no tests were included

  meta = with lib; {
    homepage = "https://github.com/LLNL/certipy";
    description = "wrapper for pyOpenSSL";
    mainProgram = "certipy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ isgy ];
  };
}
