{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "fastnumbers";
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SethMMorton";
    repo = "fastnumbers";
    tag = version;
    hash = "sha256-TC9+xOvskABpChlrSJcHy6O7D7EnIKL6Ekt/vaLBX2E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ typing-extensions ];

  # Tests fail due to numeric precision differences on ARM
  # See https://github.com/SethMMorton/fastnumbers/issues/28
  doCheck = !stdenv.hostPlatform.isAarch;

  nativeCheckInputs = [
    hypothesis
    numpy
    pytestCheckHook
  ];

  pytestFlags = [ "--hypothesis-profile=standard" ];

  pythonImportsCheck = [ "fastnumbers" ];

  meta = with lib; {
    description = "Python module for number conversion";
    homepage = "https://github.com/SethMMorton/fastnumbers";
    changelog = "https://github.com/SethMMorton/fastnumbers/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
