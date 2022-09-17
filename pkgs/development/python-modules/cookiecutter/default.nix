{ lib, buildPythonPackage, fetchPypi, isPyPy
, pytest, pytest-cov, pytest-mock, freezegun
, jinja2, future, binaryornot, click, jinja2_time, requests
, python-slugify
, pyyaml
}:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "2.1.1";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-85gr6NnFPawSYYZAE/3sf4Ov0uQu3m9t0GnF4UnFQNU=";
  };

  checkInputs = [ pytest pytest-cov pytest-mock freezegun ];
  propagatedBuildInputs = [
    binaryornot
    jinja2
    click
    pyyaml
    jinja2_time
    python-slugify
    requests
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
