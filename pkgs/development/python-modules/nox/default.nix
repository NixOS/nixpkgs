{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, argcomplete
, colorlog
, packaging
, virtualenv
, pytestCheckHook
, pytest-cov
, jinja2
, tox
}:

buildPythonPackage rec {
  pname = "nox";
  version = "2022.11.21";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = pname;
    rev = version;
    hash = "sha256-N70yBZyrtdQvgaJzkskG3goHit8eH0di9jHycuAwzfU=";
  };

  nativeBuildInputs = [
    pytestCheckHook
    pytest-cov
  ];

  propagatedBuildInputs = [
    argcomplete
    colorlog
    packaging
    virtualenv
  ];

  checkInputs = [
    jinja2
    tox
  ];

  meta = with lib; {
    homepage = "https://nox.thea.codes/";
    description = "Flexible test automation for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
