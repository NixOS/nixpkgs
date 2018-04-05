{ lib, buildPythonPackage, fetchPypi, pytz, pytest }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x98qqqw35xllpcama013a9788ly84z8dm1w2wwfpxh2710c8df5";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ garbas ];
  };
}
