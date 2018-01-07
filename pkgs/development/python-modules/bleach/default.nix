{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, six
, html5lib
}:

buildPythonPackage rec {
  pname = "bleach";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38fc8cbebea4e787d8db55d6f324820c7f74362b70db9142c1ac7920452d1a19";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six html5lib ];

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
    homepage = https://github.com/mozilla/bleach;
    downloadPage = https://github.com/mozilla/bleach/releases;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prikhi ];
  };
}