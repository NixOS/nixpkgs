{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests-oauthlib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymyob";
  version = "1.2.24";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uptick";
    repo = pname;
    rev = version;
    hash = "sha256-+ltztCm3eGYB5Fn7AQNkB2RRFxOJGcewfDj9djetF9s=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "myob" ];

  meta = with lib; {
    description = "A Python API around MYOB's AccountRight API";
    homepage = "https://github.com/uptick/pymyob";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
