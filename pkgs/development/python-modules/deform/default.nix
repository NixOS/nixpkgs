{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope-deprecation
, nose, coverage, beautifulsoup4, flaky, pyramid, pytestCheckHook }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e912937650c1dbb830079dd9c039950762a230223a567740fbf1b23f1090367";
  };

  propagatedBuildInputs = [
    chameleon
    colander
    iso8601
    peppercorn
    translationstring
    zope-deprecation
  ];

  nativeCheckInputs = [
    nose
    coverage
    beautifulsoup4
    flaky
    pyramid
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Form library with advanced features like nested forms";
    homepage = "https://docs.pylonsproject.org/projects/deform/en/latest/";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
