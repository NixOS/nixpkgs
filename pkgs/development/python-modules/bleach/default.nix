{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, html5lib
, setuptools
, packaging
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bleach";
  version = "4.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CQDYs366YagC7kCsAGH4wrXe4pwZJ90dIz4HXr9acdo=";
  };

  propagatedBuildInputs = [
    packaging
    six
    html5lib
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Disable network tests
    "protocols"
  ];

  pythonImportsCheck = [ "bleach" ];

  meta = with lib; {
    description = "An easy, HTML5, whitelisting HTML sanitizer";
    longDescription = ''
      Bleach is an HTML sanitizing library that escapes or strips markup and
      attributes based on a white list. Bleach can also linkify text safely,
      applying filters that Django's urlize filter cannot, and optionally
      setting rel attributes, even on links already in the text.

      Bleach is intended for sanitizing text from untrusted sources. If you
      find yourself jumping through hoops to allow your site administrators
      to do lots of things, you're probably outside the use cases. Either
      trust those users, or don't.
    '';
    homepage = "https://github.com/mozilla/bleach";
    downloadPage = "https://github.com/mozilla/bleach/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ prikhi ];
  };
}
