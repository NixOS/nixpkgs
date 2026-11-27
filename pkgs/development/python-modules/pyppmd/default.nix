{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  setuptools,
  setuptools-scm,
  hypothesis,
  pytest-benchmark,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "miurahr";
    repo = "pyppmd";
    tag = "v${version}";
    hash = "sha256-nry9MbyzU4blv7DQn8MV6/5694d7CFAWmZc27YKUw6g=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-benchmark
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [
    "pyppmd"
  ];

  meta = {
    description = "PPMd compression/decompression library";
    homepage = "https://codeberg.org/miurahr/pyppmd";
    changelog = "https://codeberg.org/miurahr/pyppmd/src/tag/v${version}/Changelog.rst#v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pitkling
      PopeRigby
    ];
  };
}
