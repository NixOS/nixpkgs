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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Tests started failing with numpy 1.24
    "test_numpy_numeric_type_complex"
    "test_numpy_numeric_type_float"
    "test_numpy_numeric_type_int"
  ];

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
