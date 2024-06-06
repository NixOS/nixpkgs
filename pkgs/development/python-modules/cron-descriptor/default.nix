{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cron_descriptor";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "cron-descriptor";
    rev = "refs/tags/${version}";
    hash = "sha256-r5TMatjNYaPhPxhJbBGGshQf6VxKyBV6Za1lQoblxYA=";
  };

  # remove tests_require, as we don't do linting anyways
  postPatch = ''
    sed -i "/'pep8\|flake8\|pep8-naming',/d" setup.py
  '';

  checkInputs = [ mock ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  pythonImportsCheck = [ "cron_descriptor" ];

  meta = with lib; {
    description = "Library that converts cron expressions into human readable strings";
    homepage = "https://github.com/Salamek/cron-descriptor";
    license = licenses.mit;
    maintainers = with maintainers; [ phaer ];
  };
}
