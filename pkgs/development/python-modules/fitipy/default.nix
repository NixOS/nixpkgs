{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "fitipy";
  # do not update to 1.0.0, https://github.com/MycroftAI/mycroft-precise/pull/99/commits/c668c4e53cce2e1b43464043e69ed99d3a7269fb
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ygra7xrjdicyiljzrcxqnzxskfh9lnm9r4ka3sqb9hpphsmqd92";
  };

  meta = with lib; {
    description = "A simple Python filesystem interface";
    homepage = "https://github.com/MatthewScholefield/fitipy";
    maintainers = with maintainers; [ timokau ];
    license = licenses.mit;
  };
}
