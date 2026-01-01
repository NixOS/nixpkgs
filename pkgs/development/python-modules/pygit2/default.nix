{
  lib,
  stdenv,
  buildPythonPackage,
  cacert,
  cached-property,
  cffi,
  fetchPypi,
  isPyPy,
  libgit2,
  pycparser,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygit2";
<<<<<<< HEAD
  version = "1.19.0";
=======
  version = "1.18.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-yl2285WnQWagGdd3iV+WvLIR7mDOC+QTKxOWA+AGbYM=";
=======
    hash = "sha256-7Kh+BmLJZXFbfxNJHV6FjfLAkINB3um94rwDJo5GD1U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  build-system = [ setuptools ];

  buildInputs = [ libgit2 ];

  dependencies = [
    cached-property
    pycparser
  ]
  ++ lib.optionals (!isPyPy) [ cffi ];

  propagatedNativeBuildInputs = lib.optionals (!isPyPy) [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Disable tests that require networking
    "test/test_repository.py"
    "test/test_credentials.py"
    "test/test_submodule.py"
  ];

  # Tests require certificates
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582674047
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  pythonImportsCheck = [ "pygit2" ];

<<<<<<< HEAD
  meta = {
    description = "Set of Python bindings to the libgit2 shared library";
    homepage = "https://github.com/libgit2/pygit2";
    changelog = "https://github.com/libgit2/pygit2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Set of Python bindings to the libgit2 shared library";
    homepage = "https://github.com/libgit2/pygit2";
    changelog = "https://github.com/libgit2/pygit2/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
