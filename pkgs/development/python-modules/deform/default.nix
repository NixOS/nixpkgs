{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope_deprecation
, nose, coverage, beautifulsoup4, flaky }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "874d3346a02c500432efdcc73b1a7174aa0ea69cd52a99bb9a812967f54f6f79";
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
