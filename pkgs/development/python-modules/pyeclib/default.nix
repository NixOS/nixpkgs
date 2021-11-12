{ lib, buildPythonPackage, fetchPypi, liberasurecode, six }:

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
  '';

  preBuild = ''
    # required for the custom find_library function in setup.py
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ liberasurecode ]}"
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
