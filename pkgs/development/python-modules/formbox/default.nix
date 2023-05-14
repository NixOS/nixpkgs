{ lib, buildPythonPackage, pythonOlder, fetchFromSourcehut, bleach, markdown }:

buildPythonPackage rec {
  pname = "formbox";
  version = "0.4.1";
  format = "flit";
  disabled = pythonOlder "3.6";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    hash = "sha256-zOvXmSeBiwc0Z5mRMwMsHLU3A/iP7rpjXm0T0I2gUTk=";
  };

  propagatedBuildInputs = [ bleach markdown ];
  doCheck = false; # there's no test
  pythonImportsCheck = [ "formbox" ];

  meta = with lib; {
    description = "A script to format mbox as HTML/XML";
    homepage = "https://sr.ht/~cnx/formbox";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
