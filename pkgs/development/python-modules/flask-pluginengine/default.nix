{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "flask-pluginengine";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "indico";
    repo = "flask-pluginengine";
    rev = "v${version}";
    hash = "sha256-O41z1GYA4pau6UP2rw4aU4SMr3sXsn4yd+yMvVNwT0k=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.importlib-metadata
  ];

  propagatedBuildInputs = [
    python3.pkgs.flask
  ];

  pythonImportsCheck = [ "flask_pluginengine" ];

  meta = with lib; {
    description = "Plugin system for Flask applications";
    homepage = "https://github.com/indico/flask-pluginengine";
    changelog = "https://github.com/indico/flask-pluginengine/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "flask-pluginengine";
  };
}
