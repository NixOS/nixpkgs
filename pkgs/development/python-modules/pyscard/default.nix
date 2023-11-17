{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, setuptools
, pkg-config
, swig
, pcsclite
, PCSC
, pytestCheckHook
}:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.isDarwin;
in

buildPythonPackage rec {
  version = "2.0.7";
  pname = "pyscard";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "pyscard";
    rev = "refs/tags/${version}";
    hash = "sha256-nkDI1OPQ4SsNhWkg53ZTsG7j0+mvpkJI7dsyaOl1a/8=";
  };

  nativeBuildInputs = [
    setuptools
    swig
  ] ++ lib.optionals (!withApplePCSC) [
    pkg-config
  ];

  buildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch =
    if withApplePCSC then ''
      substituteInPlace smartcard/scard/winscarddll.c \
        --replace "/System/Library/Frameworks/PCSC.framework/PCSC" \
                  "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
    '' else ''
      substituteInPlace setup.py --replace "pkg-config" "$PKG_CONFIG"
      substituteInPlace smartcard/scard/winscarddll.c \
        --replace "libpcsclite.so.1" \
                  "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
    '';

  preCheck = ''
    # remove src module, so tests use the installed module instead
    rm -r smartcard
  '';

  meta = with lib; {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ layus ];
  };
}
