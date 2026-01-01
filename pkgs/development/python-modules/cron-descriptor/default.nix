{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
<<<<<<< HEAD
  pytestCheckHook,
  setuptools,
  typing-extensions,
=======
  unittestCheckHook,
  mock,
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "cron-descriptor";
<<<<<<< HEAD
  version = "2.0.6";
=======
  version = "1.4.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "cron-descriptor";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-f7TQ3wvcHrzefZowUvxl1T0LCGeCnvpPI/IZn4XcDa4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
=======
    hash = "sha256-ElYma6RH2u1faIgOvGpMQA26dSIibWcO4mWU6NAA5PQ=";
  };

  # remove tests_require, as we don't do linting anyways
  postPatch = ''
    sed -i "/'pep8\|flake8\|pep8-naming',/d" setup.py
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    unittestCheckHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "cron_descriptor" ];

<<<<<<< HEAD
  meta = {
    description = "Library that converts cron expressions into human readable strings";
    homepage = "https://github.com/Salamek/cron-descriptor";
    changelog = "https://github.com/Salamek/cron-descriptor/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phaer ];
=======
  meta = with lib; {
    description = "Library that converts cron expressions into human readable strings";
    homepage = "https://github.com/Salamek/cron-descriptor";
    changelog = "https://github.com/Salamek/cron-descriptor/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ phaer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
