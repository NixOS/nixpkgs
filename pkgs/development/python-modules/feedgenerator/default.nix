{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytestCheckHook
, pythonOlder
, pytz
, six
}:

buildPythonPackage rec {
  pname = "feedgenerator";
  version = "2.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8HXyPyj9In8JfDayEhYcbPAS4cbKr3/1PV1rsCzUK50=";
  };

  postPatch = ''
    sed -i '/cov/d' setup.cfg
  '';

  buildInputs = [
    glibcLocales
  ];

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [
    pytz
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "feedgenerator" ];

  meta = with lib; {
    description = "Standalone version of Django's feedgenerator module";
    homepage = "https://github.com/getpelican/feedgenerator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
