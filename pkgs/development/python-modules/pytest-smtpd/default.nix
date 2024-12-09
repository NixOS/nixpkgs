{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  pytest,
  smtpdfix,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-smtpd";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # Pypi tarball doesn't include tests/
  src = fetchFromGitHub {
    owner = "bebleo";
    repo = "pytest-smtpd";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vu2D2hfxBYxgXQ4Gjr+jFpac9fjpLL2FftBhnqrcQaA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    smtpdfix
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_smtpd" ];

  meta = with lib; {
    description = "Pytest fixture that creates an SMTP server";
    homepage = "https://github.com/bebleo/pytest-smtpd";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
