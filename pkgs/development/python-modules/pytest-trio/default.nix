{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, trio, async_generator, hypothesis, outcome, pytest, pytestcov }:

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

  propagatedBuildInputs = [
    trio
    async_generator
    outcome
    pytest
  ];

  checkInputs = [
    pytest
    pytestcov
    hypothesis
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin for trio";
    homepage = "https://github.com/python-trio/pytest-trio";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
