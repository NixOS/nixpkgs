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
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ee95f6167129859c5dce9b1ca291ebdb5d8cd7e382ca0e237dfd0dad63f63d8";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six html5lib ];

  postPatch = ''
    substituteInPlace setup.py --replace ",<3dev" ""
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
    homepage = https://github.com/mozilla/bleach;
    downloadPage = https://github.com/mozilla/bleach/releases;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prikhi ];
  };
}
