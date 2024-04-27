{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch2
, setuptools
, robotframework
, approvaltests
, pytest-mockito
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "robotframework-pythonlibcore";
  version = "4.4.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-282A4EW88z6ODSIEIIeBbN8YO491rwI4M7njI7kL3XQ=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/robotframework/PythonLibCore/commit/8b756a4bd119d660109437023789bfada21bdc78.patch";
      hash = "sha256-4NtgkGbIj9gH9Det6VNh1MpGSGroESxQ8X2ZTeoX/zU=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    robotframework
  ];

  nativeCheckInputs = [
    approvaltests
    pytest-mockito
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "robotlibcore" ];

  meta = {
    changelog = "https://github.com/robotframework/PythonLibCore/blob/${src.rev}/docs/PythonLibCore-${version}.rst";
    description = "Tools to ease creating larger test libraries for Robot Framework using Python";
    homepage = "https://github.com/robotframework/PythonLibCore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
