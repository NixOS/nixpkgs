{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope_deprecation
, nose, coverage, beautifulsoup4, flaky }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8936b70c622406eb8c8259c88841f19eb2996dffcf2bac123126ada851da7271";
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
    homepage = "https://docs.pylonsproject.org/projects/deform/en/latest/";
    license = licenses.free; # http://www.repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
