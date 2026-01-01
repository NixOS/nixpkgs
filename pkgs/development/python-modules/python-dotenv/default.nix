{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  ipython,
<<<<<<< HEAD
=======
  mock,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  setuptools,
  sh,
}:

buildPythonPackage rec {
  pname = "python-dotenv";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theskumar";
    repo = "python-dotenv";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YOwe/MHIyGdt6JqiwXwYi1cYxyPkGsBdUhjoG2Ks0y0=";
=======
    hash = "sha256-GeN6/pnqhm7TTP+H9bKhJat6EwEl2EPl46mNSJWwFKk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

<<<<<<< HEAD
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

  meta = {
    changelog = "https://github.com/theskumar/python-dotenv/blob/${src.tag}/CHANGELOG.md";
    description = "Add .env support to your django/flask apps in development and deployments";
    mainProgram = "dotenv";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ erikarvstedt ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
