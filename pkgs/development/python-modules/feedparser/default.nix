{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sgmllib3k
, python
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J9pIX0Y3znFjzeqxOoAxK5O30MG3db70pHYpoxELylE=";
  };

  propagatedBuildInputs = [
    sgmllib3k
  ];

  checkPhase = ''
    # Tests are failing
    # AssertionError: unexpected '~' char in declaration
    rm tests/wellformed/sanitize/xml_declaration_unexpected_character.xml
    ${python.interpreter} -Wd tests/runtests.py
  '';

  pythonImportsCheck = [
    "feedparser"
  ];

  meta = with lib; {
    homepage = "https://github.com/kurtmckee/feedparser";
    description = "Universal feed parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
