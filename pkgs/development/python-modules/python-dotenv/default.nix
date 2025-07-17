{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  ipython,
  mock,
  pytestCheckHook,
  setuptools,
  sh,
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theskumar";
    repo = "python-dotenv";
    tag = "v${version}";
    hash = "sha256-jpSOChCUgJxrA5n+DNQX3dtFQ5Q6VG4g4pdWRIh+dOo=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  nativeCheckInputs = [
    ipython
    mock
    pytestCheckHook
    sh
  ];

  disabledTests = [ "cli" ];

  pythonImportsCheck = [ "dotenv" ];

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    mainProgram = "dotenv";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
