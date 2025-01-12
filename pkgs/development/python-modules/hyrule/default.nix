{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hyrule";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hylang";
    repo = "hyrule";
    rev = "refs/tags/${version}";
    hash = "sha256-w1Q2w/P1bDt/F1+zTkUFi5PxycXXE3p0qadfBcyWElg=";
  };

  build-system = [ setuptools ];

  dependencies = [ hy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Some tests depends on hy on PATH
  preCheck = "PATH=${hy}/bin:$PATH";

  pythonImportsCheck = [ "hyrule" ];

  meta = with lib; {
    description = "Utility library for the Hy programming language";
    homepage = "https://github.com/hylang/hyrule";
    changelog = "https://github.com/hylang/hylure/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
