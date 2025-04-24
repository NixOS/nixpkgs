{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  dataclasses-json,
  requests,
  pytestCheckHook,
  pytest-xdist,
  requests-mock,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pyecotrend-ista";
  version = "3.3.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Ludy87";
    repo = "pyecotrend-ista";
    rev = "refs/tags/${version}";
    hash = "sha256-TZDHEaDc7UACIAHNX1fStJH74qLKf+krWbTDtemXahA=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
    dataclasses-json
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    requests-mock
    syrupy
  ];

  pythonImportsCheck = [ "pyecotrend_ista" ];

  meta = {
    changelog = "https://github.com/Ludy87/pyecotrend-ista/releases/tag/${version}";
    description = "Unofficial python library for the pyecotrend-ista API";
    homepage = "https://github.com/Ludy87/pyecotrend-ista";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oynqr ];
  };
}
