{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-reverse";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "pytest-reverse";
    tag = version;
    hash = "sha256-d9wx4N3RnPbOk+dZuJaCdbtXfQQwjGo5MwVNrNVGtlo=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_reverse" ];

  meta = with lib; {
    description = "Pytest plugin to reverse test order";
    homepage = "https://github.com/adamchainz/pytest-reverse";
    changelog = "https://github.com/adamchainz/pytest-reverse/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
