{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, niapy
, numpy
, poetry-core
, pytestCheckHook
, pythonOlder
, scikit-learn
, torch
}:

buildPythonPackage rec {
  pname = "nianet";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SasoPavlic";
    repo = pname;
    rev = "Latest";
    sha256 = "sha256-df3kOWs17fT74dyKF2ZqPNOhMeH8yDEDkJOsMtFNHsM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    niapy
    numpy
    scikit-learn
    torch
  ];

  # no serious tests | some tests are incorrect | skip for now
  # reported to the upstream
  #checkInputs = [
  #  pytestCheckHook
  #];

  pythonImportsCheck = [
    "nianet"
  ];

  meta = with lib; {
    description = "Designing and constructing neural network topologies using nature-inspired algorithms";
    homepage = "https://github.com/SasoPavlic/NiaNet";
    changelog = "https://github.com/SasoPavlic/NiaNet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
