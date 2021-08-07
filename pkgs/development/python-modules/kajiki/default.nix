{ lib
, buildPythonPackage
, fetchPypi
, Babel
, pytz
, nine
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7a1f033b5cfaafa97bda5a475f58a7abcd76b348494995428fdcf6c8f648ad9";
  };

  propagatedBuildInputs = [ Babel pytz nine ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
