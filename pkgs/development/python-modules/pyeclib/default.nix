{ lib, stdenv, buildPythonPackage, fetchFromGitHub, liberasurecode, six }:

buildPythonPackage rec {
  pname = "pyeclib";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "pyeclib";
    rev = "refs/tags/${version}";
    hash = "sha256-pa3majZ68+DQGtgGCpZVRshof+w9jvpxreo4dkckLXk=";
  };

  postPatch = ''
    # patch dlopen call
    substituteInPlace src/c/pyeclib_c/pyeclib_c.c \
      --replace "liberasurecode.so" "${liberasurecode}/lib/liberasurecode.so"
    # python's platform.platform() doesn't return "Darwin" (anymore?)
    substituteInPlace setup.py \
      --replace '"Darwin"' '"macOS"'
  '';

  preBuild = let
    ldLibraryPathEnvName = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    # required for the custom _find_library function in setup.py
    export ${ldLibraryPathEnvName}="${lib.makeLibraryPath [ liberasurecode ]}"
  '';

  buildInputs = [ liberasurecode ];

  nativeCheckInputs = [ six ];

  pythonImportsCheck = [ "pyeclib" ];

  meta = with lib; {
    description = "This library provides a simple Python interface for implementing erasure codes.";
    homepage = "https://github.com/openstack/pyeclib";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
