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
  version = "1.9.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sG1pQej9aiyecXkQeehsvno3iMciRKzAbwWTtJzaN5s=";
  };

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
