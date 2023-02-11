{ lib
, stdenv
, buildPythonPackage
, cacert
, cached-property
, cffi
, fetchPypi
, isPyPy
, libgit2
, pycparser
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygit2";
  version = "1.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eT9YP9M2IPCsODdtsPV3aO8pIribRZ51saxEA3frZOw=";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  buildInputs = [
    libgit2
  ];

  propagatedBuildInputs = [
    cached-property
    pycparser
  ] ++ lib.optionals (!isPyPy) [
    cffi
  ];

  propagatedNativeBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disable tests that require networking
    "test/test_repository.py"
    "test/test_credentials.py"
    "test/test_submodule.py"
  ];

  # Tests require certificates
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582674047
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  # setup.py check is broken
  # https://github.com/libgit2/pygit2/issues/868
  dontUseSetuptoolsCheck = true;

  # TODO: Test collection is failing
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582681068
  doCheck = false;

  pythonImportsCheck = [
    "pygit2"
  ];

  meta = with lib; {
    description = "A set of Python bindings to the libgit2 shared library";
    homepage = "https://github.com/libgit2/pygit2";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
