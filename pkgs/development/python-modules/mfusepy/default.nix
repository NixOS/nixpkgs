{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fuse3,
  pytestCheckHook,
  pytest-order,
}:

let
  version = "3.2.0";
in
buildPythonPackage {
  pname = "mfusepy";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxmlnkn";
    repo = "mfusepy";
    tag = "v${version}";
    hash = "sha256-/WAGWZ+A/d5YDeuzdnApmWRDadm2aSuoqoM0XFXK9yY=";
  };

  # If fuse library path cannot be found, use fuse library path in nixpkgs
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace mfusepy.py \
      --replace-fail "_libfuse_path = find_library('fuse3')" '_libfuse_path = "${lib.getLib fuse3}/lib/libfuse3.so.4"'
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pytestCheckHook
    pytest-order
    stdenv.cc
  ];

  preCheck = ''
    export FUSE_INCLUDE_DIR="${lib.getDev fuse3}/include/fuse3"
  '';

  disabledTestPaths = [
    # These mount real FUSE file systems, which the build sandbox cannot do.
    "tests/test_examples.py"
    "tests/test_acl_enforcement.py"
  ];

  # https://github.com/NixOS/nixpkgs/blob/1e1947e8b7962c914b725e8b821e311229e632ae/doc/packages/fuse.section.md?plain=1#L10
  pythonImportsCheck = lib.optionals stdenv.hostPlatform.isLinux [ "mfusepy" ];

  meta = {
    description = "Ctypes bindings for the high-level API in libfuse 2 and 3";
    homepage = "https://github.com/mxmlnkn/mfusepy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
