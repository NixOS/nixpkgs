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
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0d6dfa27eb2b6c0d2a28ae21d69dceb5363cc0432f4045bcc98aac42a662ccb";
  };

  propagatedBuildInputs = [ Babel pytz nine ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
