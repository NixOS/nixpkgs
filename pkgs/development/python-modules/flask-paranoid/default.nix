{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-paranoid";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0WWc/ktAOuTk4A75xI1jCj/aef2+1TjLKBA9+PRfJO0=";
  };

  postPatch = ''
    # tests have a typo in one of the assertions
    substituteInPlace tests/test_paranoid.py --replace "01-Jan-1970" "01 Jan 1970"
  '';

  propagatedBuildInputs = [
    flask
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flask_paranoid" ];

  meta = with lib; {
    homepage = "https://github.com/miguelgrinberg/flask-paranoid/";
    description = "Simple user session protection";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
