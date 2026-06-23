{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ludy87";
    repo = "pyecotrend-ista";
    tag = version;
    hash = "sha256-O5HU0U19E+cS1/UVYouxbyTBNjenJw9kkH80GCZ04cw=";
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
