{ lib, stdenv, buildPythonPackage, fetchPypi, liberasurecode, six }:

buildPythonPackage rec {
  pname = "pyeclib";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gBHjHuia5/uZymkWZgyH4BCEZqmWK9SXowAQIJdOO7E=";
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

  checkInputs = [ six ];

  pythonImportsCheck = [ "pyeclib" ];

  meta = with lib; {
    description = "This library provides a simple Python interface for implementing erasure codes.";
    homepage = "https://github.com/openstack/pyeclib";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
