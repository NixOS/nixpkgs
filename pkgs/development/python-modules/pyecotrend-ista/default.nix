{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  dataclasses-json,
  requests,
  pytestCheckHook,
  pytest-xdist,
  requests-mock,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pyecotrend-ista";
  version = "3.3.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Ludy87";
    repo = "pyecotrend-ista";
    tag = version;
    hash = "sha256-x9teLjIJPLYi/mE6vy4KBUl7NI4aAwWPYSEwYZQ+4I4=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

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
