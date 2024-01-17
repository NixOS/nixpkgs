{ lib
, buildPythonPackage
, setuptools
, cachetools
, decorator
, fetchFromGitHub
, pysmt
, pythonOlder
, pytestCheckHook
, z3-solver
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.85";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    rev = "refs/tags/v${version}";
    hash = "sha256-jMACLZN7hYukUgavtdpdVjV1WmPF9UupaNi/FE2Y2aM=";
  };

  postPatch = ''
    # The detection doesn't seem to work for z3-solver
    substituteInPlace setup.cfg \
      --replace "z3-solver==4.10.2.0" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cachetools
    decorator
    pysmt
    z3-solver
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "claripy"
  ];

  meta = with lib; {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
