{ lib, buildPythonPackage, fetchPypi
, beautifulsoup4, peppercorn, colander, translationstring
, chameleon, zope_deprecation, coverage, nose }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0a2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fa4d287c8da77a83556e4a5686de006ddd69da359272120b915dc8f5a70cabd";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    peppercorn
    colander
    translationstring
    chameleon
    zope_deprecation
    coverage
    nose
  ];

  meta = with lib; {
    description = "Form library with advanced features like nested forms";
    homepage = https://docs.pylonsproject.org/projects/deform/en/latest/;
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
