{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  hatchling,

  # dependencies
  bleak,
  pycayennelpp,
  pyserial-asyncio-fast,
  pycryptodome,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "meshcore";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore_py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vz2LQaP44Yojf9h2rSBvKRjW99IOj7C5MxqQnIUoIRE=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/meshcore-dev/meshcore_py/pull/71
      url = "https://github.com/meshcore-dev/meshcore_py/commit/9294e574739844e0e291b972b40e1a0a40149e47.patch";
      hash = "sha256-Ufr+5rDDO32W6dtD7wEU34iLJai3H0dBCEtLS5j4u/0=";
    })
  ];

  build-system = [ hatchling ];

  dependencies = [
    bleak
    pycayennelpp
    pyserial-asyncio-fast
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "meshcore" ];

  meta = {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    changelog = "https://github.com/meshcore-dev/meshcore_py/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haylin ];
  };
})
