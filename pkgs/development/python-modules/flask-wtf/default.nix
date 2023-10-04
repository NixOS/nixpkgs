{ lib
, fetchFromGitHub
, buildPythonPackage
, flask
, itsdangerous
, wtforms
, email-validator
, pytestCheckHook
, hatchling
}:

buildPythonPackage rec {
  pname = "flask-wtf";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "flask-wtf";
    rev = "v${version}";
    sha256 = "sha256-FU82oGIL6X9/29FPZ87ModNKjLtJuR1lQ2mM1facNls=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    flask
    itsdangerous
    wtforms
  ];

  passthru.optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 anthonyroussel ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
