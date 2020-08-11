{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope_deprecation
, nose, coverage, beautifulsoup4, flaky }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f4e98a5b5bdcdfff9a62f88bd17c7ee378b7c8be61738797442eed5b961d3d2";
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
