{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, hatch-vcs
, numpy
, pythonOlder
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyhamcrest";
  version = "2.0.4";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "PyHamcrest";
    rev = "refs/tags/V${version}";
    hash = "sha256-CIkttiijbJCR0zdmwM5JvFogQKYuHUXHJhdyWonHcGk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  checkInputs = [
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/hamcrest/PyHamcrest";
    description = "Hamcrest framework for matcher objects";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      alunduil
    ];
  };
}
