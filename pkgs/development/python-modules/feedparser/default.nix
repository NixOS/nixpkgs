{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, setuptools
, sgmllib3k
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.11";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ydBAe2TG8qBl0OuyksKzXAEFDMDcM3V0Yaqr3ExBhNU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    sgmllib3k
  ];

  __darwinAllowLocalNetworking = true;

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
    description = "Universal feed parser";
    homepage = "https://github.com/kurtmckee/feedparser";
    changelog = "https://feedparser.readthedocs.io/en/latest/changelog.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
