{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "getpelican";
     repo = "feedgenerator";
     rev = "1.9.2";
     sha256 = "0p81m7zyzf5hd68ls95mx8qn6iaiwjylzinmy1h3d960ndihdykj";
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
