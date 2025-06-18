{
  lib,
  stdenv,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  liberasurecode,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pyeclib";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "pyeclib";
    tag = version;
    hash = "sha256-oRitXlQunfqLSKMaSW3E1BnL0otA4UPj/y6bbiN0kPM=";
  };

  postPatch = ''
    # python's platform.platform() doesn't return "Darwin" (anymore?)
    substituteInPlace setup.py \
      --replace-fail '"Darwin"' '"macOS"'
  '';

  build-system = [
    distutils
    setuptools
  ];

  preBuild =
    let
      ldLibraryPathEnvName =
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      # required for the custom _find_library function in setup.py
      export ${ldLibraryPathEnvName}="${lib.makeLibraryPath [ liberasurecode ]}"
    '';

  dependencies = [ liberasurecode ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  disabledTests = [
    # The memory usage goes *down* on Darwin, which the test confuses for an increase and fails
    "test_get_metadata_memory_usage"
  ];

  pythonImportsCheck = [ "pyeclib" ];

  meta = with lib; {
    description = "This library provides a simple Python interface for implementing erasure codes";
    homepage = "https://github.com/openstack/pyeclib";
    license = licenses.bsd2;
    teams = [ teams.openstack ];
  };
}
