{ lib
, buildPythonPackage
, fetchPypi
, babel
, pytz
, nine
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Qe/FTQ6YrHiVklP3HFG9HsT7Yny6we2+Ithcj2UFdp4=";
  };

  propagatedBuildInputs = [ babel pytz nine ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
