{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  PCSC,
  pcsclite,
  pkg-config,
  pytestCheckHook,
  setuptools,
  stdenv,
  swig,
}:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.hostPlatform.isDarwin;
in

buildPythonPackage rec {
  pname = "pyscard";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "pyscard";
    rev = "refs/tags/${version}";
    hash = "sha256-yZeP4Tcxnwb2My+XOsMtj+H8mNIf6JYf5tpOVUYjev0=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ] ++ lib.optionals (!withApplePCSC) [ pkg-config ];

  buildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch =
    ''
      substituteInPlace pyproject.toml \
        --replace-fail 'requires = ["setuptools","swig"]' 'requires = ["setuptools"]'
    ''
    + (
      if withApplePCSC then
        ''
          substituteInPlace src/smartcard/scard/winscarddll.c \
            --replace-fail "/System/Library/Frameworks/PCSC.framework/PCSC" \
                      "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
        ''
      else
        ''
          substituteInPlace setup.py --replace-fail "pkg-config" "$PKG_CONFIG"
          substituteInPlace src/smartcard/scard/winscarddll.c \
            --replace-fail "libpcsclite.so.1" \
                      "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
        ''
    );

  meta = {
    description = "Smartcard library for python";
    homepage = "https://pyscard.sourceforge.io/";
    changelog = "https://github.com/LudovicRousseau/pyscard/releases/tag/${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ layus ];
  };
}
