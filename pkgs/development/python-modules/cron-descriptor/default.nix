{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cron-descriptor";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "cron-descriptor";
    rev = "refs/tags/${version}";
    hash = "sha256-NKAfNwIRnND4ume27CSPJoib9DysbpdD905SNP+wx0A=";
  };

  # remove tests_require, as we don't do linting anyways
  postPatch = ''
    sed -i "/'pep8\|flake8\|pep8-naming',/d" setup.py
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    unittestCheckHook
  ];

  pythonImportsCheck = [ "cron_descriptor" ];

  meta = with lib; {
    description = "Library that converts cron expressions into human readable strings";
    homepage = "https://github.com/Salamek/cron-descriptor";
    changelog = "https://github.com/Salamek/cron-descriptor/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ phaer ];
  };
}
