{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, flask }:

buildPythonPackage rec {
  pname = "Flask-SeaSurf";
  version = "0.3.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-seasurf";
    rev = version;
    sha256 = "02hsvppsz1d93v641f14fdnd22gbc12ilc9k9kn7wl119n5s3pd8";
  };

  propagatedBuildInputs = [ flask ];

  pythonImportsCheck = [ "flask_seasurf" ];

  meta = with lib; {
    description = "A Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
