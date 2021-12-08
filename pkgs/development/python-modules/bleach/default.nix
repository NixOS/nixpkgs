{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "mozilla";
     repo = "bleach";
     rev = "v4.1.0";
     sha256 = "0ihp050fwq3vzd8i35jh6ab2r4sdxskp1lny8sca81nrbgqcgsv2";
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
