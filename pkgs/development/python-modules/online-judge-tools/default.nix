{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  online-judge-api-client,
  packaging,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "online-judge-tools";
  version = "12.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "oj";
    rev = "refs/tags/v${version}";
    hash = "sha256-m6V4Sq3yU/KPnbpA0oCLI/qaSrAPA6TutcBL5Crb/Cc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    online-judge-api-client
    packaging
    requests
  ];

  pythonImportsCheck = [
    "onlinejudge"
    "onlinejudge_command"
  ];

  # Requires internet access
  doCheck = false;

  meta = with lib; {
    description = "Tools for various online judges. Download sample cases, generate additional test cases, test your code, and submit it";
    mainProgram = "oj";
    homepage = "https://github.com/online-judge-tools/oj";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
