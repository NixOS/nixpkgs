{ lib
, python3
, fetchFromGitHub
, pywebpack
}:

python3.pkgs.buildPythonPackage rec {
  pname = "flask-webpackext";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "flask-webpackext";
    rev = "v${version}";
    hash = "sha256-mwLGhvFzid7SUWQpCNeQyWb4ZZxSI5yic9Nq8AO++YE=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.pytest-runner
  ];

  propagatedBuildInputs = [
    python3.pkgs.flask
    pywebpack
  ];

  pythonImportsCheck = [ "flask_webpackext" ];

  meta = with lib; {
    description = "Webpack integration for Flask";
    homepage = "https://github.com/inveniosoftware/flask-webpackext";
    changelog = "https://github.com/inveniosoftware/flask-webpackext/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "flask-webpackext";
  };
}
