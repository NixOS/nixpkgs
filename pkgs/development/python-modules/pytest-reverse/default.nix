{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-reverse";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "pytest-reverse";
    tag = finalAttrs.version;
    hash = "sha256-d9wx4N3RnPbOk+dZuJaCdbtXfQQwjGo5MwVNrNVGtlo=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_reverse" ];

  meta = {
    description = "Pytest plugin to reverse test order";
    homepage = "https://github.com/adamchainz/pytest-reverse";
    changelog = "https://github.com/adamchainz/pytest-reverse/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
