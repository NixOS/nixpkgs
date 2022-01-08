{ lib, buildPythonPackage, pythonOlder, fetchFromSourcehut, bleach, markdown }:

buildPythonPackage rec {
  pname = "formbox";
  version = "0.1.0";
  format = "flit";
  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "sha256-6OzmYqUC3mmrAMeMExI4rdVGUoWrxRuBfjKFYbHUlgE=";
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
