{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  setuptools,

  # optional dependencies
  ifaddr,
  python-can,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycyphal2";
  version = "2.0.0.dev9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenCyphal";
    repo = "pycyphal";
    tag = version;
    hash = "sha256-s4VTQ4VxZwPZHPAHYtLk7rcJ8bZHk4Wy9jP+8Q7seXc=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    pythoncan = [ python-can ] ++ python-can.optional-dependencies.serial;
    udp = [ ifaddr ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pycyphal2" ];

  meta = {
    description = "Pure-Python implementation of the Cyphal protocol stack";
    longDescription = ''
      Cyphal in Python — decentralized real-time pub/sub with tunable reliability, service discovery, and zero configuration. Works anywhere, including baremetal MCUs.
    '';
    homepage = "https://opencyphal.org/";
    changelog = "https://github.com/OpenCyphal/pycyphal/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bjsowa ];
  };
}
