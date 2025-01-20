{
  lib,
  stdenv,
  buildPythonPackage,
  cacert,
  cached-property,
  cffi,
  fetchPypi,
  fetchpatch,
  isPyPy,
  libgit2,
  pycparser,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygit2";
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+ivAULLC0+c7VNbVQceSF4Vho0TwfkCfUy1buXrHuJQ=";
  };

  patches = [
    # fix for GCC 14
    (fetchpatch {
      url = "https://github.com/libgit2/pygit2/commit/eba710e45bb40e18641c6531394bb46631e7f295.patch";
      hash = "sha256-GFFzGVd/9+AcwicwOtBghhonijMp08svXTUZ/4/LmtI=";
    })
    # temp fix for Python 3.13 until next release after 1.16.0
    (fetchpatch {
      url = "https://github.com/libgit2/pygit2/commit/7f143e1c5beec01ec3429aa4db12435ac02977d3.patch";
      hash = "sha256-2SiFFPWVVo9urKRu64AejjTZMoXo2r+v1OwEIF+AzNo=";
    })
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${libgit2}/lib"
  '';

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ libgit2 ];

  propagatedBuildInputs = [
    cached-property
    pycparser
  ] ++ lib.optionals (!isPyPy) [ cffi ];

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

  meta = with lib; {
    description = "Set of Python bindings to the libgit2 shared library";
    homepage = "https://github.com/libgit2/pygit2";
    changelog = "https://github.com/libgit2/pygit2/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
