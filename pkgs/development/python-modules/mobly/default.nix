{ lib
, buildPythonPackage
, fetchFromGitHub

# runtime
, portpicker
, pyserial
, pyyaml
, timeout-decorator
, typing-extensions

# tests
, procps
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "mobly";
  version = "1.12.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mobly";
    rev = "refs/tags/${version}";
    hash = "sha256-leUOC8AQwbuPNphDg4bIFWW+9tTnYvM3/ejHgZDMR44=";
  };

  propagatedBuildInputs = [
    portpicker
    pyserial
    pyyaml
    timeout-decorator
    typing-extensions
  ];

  nativeCheckInputs = [
    procps
    pytestCheckHook
    pytz
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/google/mobly/blob/${src.rev}/CHANGELOG.md";
    description = "Automation framework for special end-to-end test cases";
    homepage = "https://github.com/google/mobly";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
