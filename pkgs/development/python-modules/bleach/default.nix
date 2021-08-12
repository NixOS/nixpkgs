{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-runner
, six
, html5lib
, setuptools
, packaging
}:

buildPythonPackage rec {
  pname = "bleach";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yma53plrlw2llaqxv8yk0g5al0vvlywwzym18b78m3rm6jq6r1h";
  };

  checkInputs = [ pytest pytest-runner ];
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
