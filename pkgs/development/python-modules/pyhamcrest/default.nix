{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, numpy
, pytest-xdist
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyhamcrest";
  version = "2.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "PyHamcrest";
    rev = "refs/tags/V${version}";
    hash = "sha256-CIkttiijbJCR0zdmwM5JvFogQKYuHUXHJhdyWonHcGk=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  checkInputs = [
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "hamcrest"
  ];

  meta = with lib; {
    description = "Hamcrest framework for matcher objects";
    homepage = "https://github.com/hamcrest/PyHamcrest";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alunduil ];
  };
}
