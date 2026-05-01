{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytest,
  setuptools-scm,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "joseph-roitman";
    repo = "pytest-snapshot";
    tag = "v${version}";
    hash = "sha256-0PZu9wL29iEppLxxbl4D0E4WfOHe61KUUld003cRBRU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [
    # https://github.com/joseph-roitman/pytest-snapshot/issues/71
    pytest7CheckHook
  ];

  pythonImportsCheck = [ "pytest_snapshot" ];

  meta = {
    description = "Plugin to enable snapshot testing with pytest";
    homepage = "https://github.com/joseph-roitman/pytest-snapshot/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
