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
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "pyeclib";
    rev = "refs/tags/${version}";
    hash = "sha256-LZQNJU7QEoHo+RWvHnQkNxBg6t322u/c3PyBhy1eVZc=";
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

  pythonImportsCheck = [ "pyeclib" ];

  meta = with lib; {
    description = "This library provides a simple Python interface for implementing erasure codes";
    homepage = "https://github.com/openstack/pyeclib";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
