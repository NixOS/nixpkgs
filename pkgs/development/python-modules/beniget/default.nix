{ lib
, buildPythonPackage
, fetchPypi
, gast
}:

buildPythonPackage rec {
  pname = "beniget";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72bbd47b1ae93690f5fb2ad3902ce1ae61dcd868ce6cfbf33e9bad71f9ed8749";
  };

  propagatedBuildInputs = [
    gast
  ];

  meta = {
    description = "Extract semantic information about static Python code";
    homepage = "https://github.com/serge-sans-paille/beniget";
    license = lib.licenses.bsd3;
  };
}
