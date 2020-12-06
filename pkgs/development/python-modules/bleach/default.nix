{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, six
, html5lib
, setuptools
, packaging
}:

buildPythonPackage rec {
  pname = "bleach";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52b5919b81842b1854196eaae5ca29679a2f2e378905c346d3ca8227c2c66080";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ packaging six html5lib setuptools ];

  # Disable network tests
  checkPhase = ''
    pytest -k "not protocols"
  '';

  meta = {
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prikhi ];
  };
}
