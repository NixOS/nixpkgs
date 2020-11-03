{ lib, buildPythonPackage, fetchPypi
, chameleon, colander, iso8601, peppercorn, translationstring, zope_deprecation
, nose, coverage, beautifulsoup4, flaky, pyramid, pytestCheckHook }:

buildPythonPackage rec {
  pname = "deform";
  version = "2.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35d9acf144245772a70d05bd24b8263e8cd284f0d564011e8bf331d6150acfc7";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "iso8601<=0.1.11" iso8601
  '';

  requiredPythonModules = [
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
