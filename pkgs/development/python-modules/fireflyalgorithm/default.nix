{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "FireflyAlgorithm";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = version;
    sha256 = "sha256-IlOIoP2aANE8y3+Qtb/H6w/+REnPWiUUQGRiAfxOpcM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fireflyalgorithm"
  ];

  meta = with lib; {
    description = "An implementation of the stochastic nature-inspired algorithm for optimization";
    homepage = "https://github.com/firefly-cpp/FireflyAlgorithm";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
