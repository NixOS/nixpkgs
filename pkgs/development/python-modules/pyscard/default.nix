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
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "pyscard";
    rev = "refs/tags/${version}";
    hash = "sha256-DO4Ea+mlrWPpOLI8Eki+03UnsOXEhN2PAl0+gdN5sTo=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ] ++ lib.optionals (!withApplePCSC) [ pkg-config ];

  buildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch =
    if withApplePCSC then
      ''
        substituteInPlace smartcard/scard/winscarddll.c \
          --replace-fail "/System/Library/Frameworks/PCSC.framework/PCSC" \
                    "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
      ''
    else
      ''
        substituteInPlace setup.py --replace "pkg-config" "$PKG_CONFIG"
        substituteInPlace smartcard/scard/winscarddll.c \
          --replace-fail "libpcsclite.so.1" \
                    "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
      '';

  preCheck = ''
    # remove src module, so tests use the installed module instead
    rm -r smartcard
  '';

  disabledTests = [
    # AssertionError
    "test_hresult"
    "test_low_level"
  ];

  meta = with lib; {
    description = "Smartcard library for python";
    homepage = "https://pyscard.sourceforge.io/";
    changelog = "https://github.com/LudovicRousseau/pyscard/releases/tag/${version}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ layus ];
  };
}
