{ lib, buildPythonPackage, youtube-dl, fetchPypi }:
buildPythonPackage rec {
  pname = "pafy";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e842dc589a339a870b5869cc3802f2e95824edf347f65128223cd5ebdff21024";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ youtube-dl ];

  meta = with lib; {
    description = "A library to download YouTube content and retrieve metadata";
    homepage = http://np1.github.io/pafy/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ odi ];
  };
}

