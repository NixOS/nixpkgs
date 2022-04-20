{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, flask, mock, python }:

buildPythonPackage rec {
  pname = "Flask-SeaSurf";
  version = "1.1.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-seasurf";
    rev = version;
    sha256 = "sha256-L/ZUEqqHmsyXG5eShcITII36ttwQlZN5GBngo+GcCdw=";
  };

  propagatedBuildInputs = [ flask ];

  checkInputs = [
    mock
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ "flask_seasurf" ];

  meta = with lib; {
    description = "A Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
