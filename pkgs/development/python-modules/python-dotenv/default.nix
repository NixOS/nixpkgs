{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  ipython,
  pytestCheckHook,
  setuptools,
  sh,
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theskumar";
    repo = "python-dotenv";
    tag = "v${version}";
    hash = "sha256-YOwe/MHIyGdt6JqiwXwYi1cYxyPkGsBdUhjoG2Ks0y0=";
  };

  build-system = [ setuptools ];

  optional-dependencies.cli = [ click ];

  nativeCheckInputs = [
    ipython
    pytestCheckHook
    sh
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "dotenv" ];

  meta = with lib; {
    changelog = "https://github.com/theskumar/python-dotenv/blob/${src.tag}/CHANGELOG.md";
    description = "Add .env support to your django/flask apps in development and deployments";
    mainProgram = "dotenv";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
