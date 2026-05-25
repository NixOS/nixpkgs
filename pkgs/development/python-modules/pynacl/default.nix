{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  hypothesis,
  libsodium,
  pytestCheckHook,
  pytest-xdist,
  setuptools,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.6.2";
  outputs = [
    "out"
    "doc"
  ];
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "pynacl";
    tag = version;
    hash = "sha256-EzzJVRDgYQO6T8YIQjad/Eb9O+BXT4IpOpa48fpBPnc=";
  };

  build-system = [
    cffi
    setuptools
  ];

  # cffi is listed in both build-system.requires and project.dependencies,
  # and is indeed needed in both when cross-compiling
  dependencies = [ cffi ];

  nativeBuildInputs = [ sphinxHook ];

  buildInputs = [ libsodium ];

  propagatedNativeBuildInputs = [ cffi ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
  ];

  env.SODIUM_INSTALL = "system";

  pythonImportsCheck = [ "nacl" ];

  meta = {
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = "https://github.com/pyca/pynacl/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
