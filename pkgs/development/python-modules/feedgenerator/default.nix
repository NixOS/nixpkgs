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
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6836d456b8b0edbc5b6d3a42d1be852cebd43d2f28af4ff51789eb295f1860e2";
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

  checkInputs = [
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
