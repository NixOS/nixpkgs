{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, trio, async-generator, hypothesis, outcome, pytest }:

buildPythonPackage rec {
  pname = "pytest-trio";
  version = "0.8.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gUH35Yk/pBD2EdCEt8D0XQKWU8BwmX5xtAW10qRhoYk=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    trio
    async-generator
    outcome
  ];

  nativeCheckInputs = [
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
