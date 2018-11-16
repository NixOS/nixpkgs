{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope_deprecation
, nose, coverage, beautifulsoup4, flaky }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda0b809c8a668e105e30650a6766103207eafdd12c313acd59274ccd2c4d297";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "iso8601<=0.1.11" iso8601
  '';

  propagatedBuildInputs = [
    chameleon
    colander
    iso8601
    peppercorn
    translationstring
    zope_deprecation
  ];

  checkInputs = [
    nose
    coverage
    beautifulsoup4
    flaky
  ];

  meta = with lib; {
    description = "Form library with advanced features like nested forms";
    homepage = https://docs.pylonsproject.org/projects/deform/en/latest/;
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
