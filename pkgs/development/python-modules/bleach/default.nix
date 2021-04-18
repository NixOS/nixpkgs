{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytest
, pytestrunner
, six
, html5lib
, setuptools
, packaging
}:

buildPythonPackage rec {
  pname = "bleach";
  version = "3.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c4c520fdb9db59ef139915a5db79f8b51bc2a7257ea0389f30c846883430a4b";
  };

  patches = [
    ./3.1.5-CVE-2021-23980.patch
    (fetchpatch {
      name = "CVE-2021-23980-extra-tests.patch";
      url = "https://github.com/mozilla/bleach/commit/d398c89e54ced6b1039d3677689707456ba42dec.patch";
      sha256 = "1p7z6y1kfj9kfvw7cwhxmzp0inv3i3h9vzvqgls6iz7j2dxq5s2j";
    })
  ];

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
