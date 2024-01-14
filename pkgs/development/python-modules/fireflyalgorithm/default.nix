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
  version = "0.4.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xsTgSHBtN4gGw+9YvprcLubnCXSNRdn4abcz391cMEE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fireflyalgorithm"
  ];

  meta = with lib; {
    description = "An implementation of the stochastic nature-inspired algorithm for optimization";
    homepage = "https://github.com/firefly-cpp/FireflyAlgorithm";
    changelog = "https://github.com/firefly-cpp/FireflyAlgorithm/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
