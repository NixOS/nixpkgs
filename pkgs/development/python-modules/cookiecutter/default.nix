{ lib, buildPythonPackage, fetchPypi, isPyPy
, pytest, pytest-cov, pytest-mock, freezegun
, jinja2, future, binaryornot, click, whichcraft, poyo, jinja2_time, requests
, python-slugify }:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "1.7.3";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a5pNcoguJDvgd6c5fQ8fdv5mzz35HzEV27UzDiFPpFc=";
  };

  checkInputs = [ pytest pytest-cov pytest-mock freezegun ];
  propagatedBuildInputs = [
    jinja2 future binaryornot click whichcraft poyo jinja2_time requests python-slugify
  ];

  # requires network access for cloning git repos
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/audreyr/cookiecutter";
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
