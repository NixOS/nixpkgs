{
  # Basic
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build system
  poetry-core,
  # Dependencies
  numpy,
  requests,
  tsplib95,
  # Test
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "python-tsp";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fillipe-gsm";
    repo = "python-tsp";
    tag = "v${version}";
    hash = "sha256-X4L0j6ZL8/Xj2YFcvwOl8voC2xHagMcdcj9F1f/6/5M=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    requests
    tsplib95
  ];

  # Rename some dependencies
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=0.12" "poetry-core>=0.12" \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "python_tsp" ];

  meta = {
    description = "Library for solving typical Traveling Salesperson Problems (TSP)";
    homepage = "https://github.com/fillipe-gsm/python-tsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thattemperature ];
  };
}
