{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, trio, python, async_generator, hypothesis, outcome, pytest }:

buildPythonPackage rec {
  pname = "pytest-trio";
  version = "0.6.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = pname;
    rev = "v${version}";
    sha256 = "09v2031yxm8ryhq12205ldcck76n3wwqhjjsgfmn6dxfiqb0vbw9";
  };

  requiredPythonModules = [
    trio
    async_generator
    outcome
    pytest
  ];

  checkInputs = [
    pytest
    hypothesis
  ];

  # broken with pytest 5 and 6
  doCheck = false;
  checkPhase = ''
    rm pytest.ini
    PYTHONPATH=$PWD:$PYTHONPATH pytest
  '';

  pythonImportsCheck = [ "pytest_trio" ];

  meta = with lib; {
    description = "Pytest plugin for trio";
    homepage = "https://github.com/python-trio/pytest-trio";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
