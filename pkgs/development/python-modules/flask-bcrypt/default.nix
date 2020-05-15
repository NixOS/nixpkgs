{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, bcrypt
, python
}:

buildPythonPackage rec {
  pname = "flask-bcrypt";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = pname;
    rev = version;
    sha256 = "0036gag3nj7fzib23lbbpwhlrn1s0kkrfwk5pd90y4cjcfqh8z9x";
  };

  propagatedBuildInputs = [
    flask
    bcrypt
  ];

  checkPhase = ''
    ${python.interpreter} test_bcrypt.py
  '';

  meta = with lib; {
    description = "Brcrypt hashing for Flask";
    homepage = "https://github.com/maxcountryman/flask-bcrypt";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
