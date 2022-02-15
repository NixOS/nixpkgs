{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, isPy3k, libgit2, cached-property, pytestCheckHook, cffi, cacert }:

buildPythonPackage rec {
  pname = "pygit2";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bixc/1qh5D9DEDSAdhFS9cXWvvQPXB9QyHWKbonmbLY=";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  buildInputs = [
    libgit2
  ];

  propagatedBuildInputs = [
    cached-property
  ] ++ lib.optional (!isPyPy) cffi;

  propagatedNativeBuildInputs = lib.optional (!isPyPy) cffi;

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    # disable tests that require networking
    rm test/test_repository.py
    rm test/test_credentials.py
    rm test/test_submodule.py
  '';

  # Tests require certificates
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582674047
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  # setup.py check is broken
  # https://github.com/libgit2/pygit2/issues/868
  dontUseSetuptoolsCheck = true;

  # TODO: Test collection is failing
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582681068
  doCheck = false;

  disabled = !isPy3k;

  meta = with lib; {
    description = "A set of Python bindings to the libgit2 shared library";
    homepage = "https://pypi.python.org/pypi/pygit2";
    license = licenses.gpl2;
  };
}
