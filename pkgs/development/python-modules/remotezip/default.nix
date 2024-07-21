{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  tabulate,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "remotezip";
  version = "0.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtsystem";
    repo = "python-remotezip";
    rev = "refs/tags/v${version}";
    hash = "sha256-TNEM7Dm4iH4Z/P/PAqjJppbn1CKmyi9Xpq/sU9O8uxg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "remotezip" ];

  meta = with lib; {
    description = "Python module to access single members of a zip archive without downloading the full content";
    mainProgram = "remotezip";
    homepage = "https://github.com/gtsystem/python-remotezip";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
