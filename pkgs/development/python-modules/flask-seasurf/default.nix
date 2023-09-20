{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, flask, mock, unittestCheckHook }:

buildPythonPackage rec {
  pname = "Flask-SeaSurf";
  version = "1.1.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-seasurf";
    rev = version;
    hash = "sha256-L/ZUEqqHmsyXG5eShcITII36ttwQlZN5GBngo+GcCdw=";
  };

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];

  pythonImportsCheck = [ "flask_seasurf" ];

  meta = with lib; {
    description = "A Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
