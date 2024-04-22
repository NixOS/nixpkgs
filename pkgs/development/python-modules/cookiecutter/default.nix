{ lib, buildPythonPackage, fetchPypi, isPyPy
, setuptools
, pytest, pytest-cov, pytest-mock, freezegun, safety, pre-commit
, jinja2, binaryornot, click, jinja2-time, requests
, python-slugify
, pyyaml
, arrow
, rich
}:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "2.6.0";
  pyproject = true;

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2yH4Fp6k9P3CQI1IykSFk0neJkf75JSp1sPt/AVCwhw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest
    pytest-cov
    pytest-mock
    freezegun
    safety
    pre-commit
  ];
  propagatedBuildInputs = [
    binaryornot
    jinja2
    click
    pyyaml
    jinja2-time
    python-slugify
    requests
    arrow
    rich
  ];

  # requires network access for cloning git repos
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/audreyr/cookiecutter";
    description = "A command-line utility that creates projects from project templates";
    mainProgram = "cookiecutter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
