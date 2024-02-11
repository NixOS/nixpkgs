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
, setuptools
}:

buildPythonPackage rec {
  pname = "pygit2";
  version = "1.14.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7FlYVxuCpjUXhcpkXlOUwxrkXuxThLL6nE4F3eNZetY=";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  nativeBuildInputs = [
    setuptools
  ];

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

  pythonImportsCheck = [
    "pygit2"
  ];

  meta = with lib; {
    description = "A set of Python bindings to the libgit2 shared library";
    homepage = "https://github.com/libgit2/pygit2";
    changelog = "https://github.com/libgit2/pygit2/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
