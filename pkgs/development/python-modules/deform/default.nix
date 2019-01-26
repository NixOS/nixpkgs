{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope_deprecation
, nose, coverage, beautifulsoup4, flaky }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ff29c32ebe544c0f0a77087e268b2cd9cb4b11fa35af3635d5b42913f88d74a";
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
