{ lib
, stdenv
, buildPythonPackage
, cacert
, cached-property
, cffi
, fetchpatch
, fetchPypi
, isPyPy
, libgit2
, pycparser
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygit2";
  version = "1.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IIlEM98RRkgarK434rDzu7/eoCbbL1UGEXC9mCPkCxk=";
  };

  patches = [
    # libgit 2 fix
    (fetchpatch {
      url = "https://github.com/libgit2/pygit2/commit/14b1df84060ea4ab085202382e80672ec1a104e3.patch";
      includes = [ "src/types.h" ];
      sha256 = "sha256-2krkyAT30l/olSEl2ugWCsylvGuT7VvkuSFVshIXktA=";
    })
  ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  buildInputs = [
    libgit2
  ];

  propagatedBuildInputs = [
    cached-property
    pycparser
  ] ++ lib.optional (!isPyPy) [
    cffi
  ];

  propagatedNativeBuildInputs = lib.optional (!isPyPy) [
    cffi
  ];

  checkInputs = [
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
