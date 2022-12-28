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
  version = "0.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = version;
    sha256 = "sha256-C2bm2Eb2kqfCnGORAzHX7hh4qj1MtDSkAu77lcZWQKc=";
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
