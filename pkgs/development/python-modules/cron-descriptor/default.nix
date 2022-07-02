{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cron_descriptor";
  version = "1.2.27";

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "cron-descriptor";
    rev = "refs/tags/${version}";
    sha256 = "sha256-ycpBbXVUl7mIPx6p4DoVq51T86Im9bkF6LQFSYUL4uk=";
  };

  # remove tests_require, as we don't do linting anyways
  postPatch = ''
    sed -i "/'pep8\|flake8\|pep8-naming',/d" setup.py
  '';

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
