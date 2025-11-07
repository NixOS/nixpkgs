{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  olm,
  openssl,
  qtbase,
  qtmultimedia,
  qtkeychain,
}:

stdenv.mkDerivation rec {
  pname = "libquotient";
  version = "0.9.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    hash = "sha256-wdIE5LI4l3WUvpGfoJBL8sjBl2k8NfZTh9CjfJc9FIA=";
  };

  patches = [
    # Qt 6.10 compat
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://github.com/quotient-im/libQuotient/commit/ea83157eed37ff97ab275a5d14c971f0a5a70595.diff";
      hash = "sha256-JMdcywGgZ0Gev/Nce4oPiMJQxTBJYPoq+WoT3WLWWNQ=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    qtbase
    qtkeychain
    olm
    openssl
    qtmultimedia
  ];

  cmakeFlags = [
    "-DQuotient_ENABLE_E2EE=ON"
  ];

  # https://github.com/quotient-im/libQuotient/issues/551
  postPatch = ''
    substituteInPlace Quotient.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  dontWrapQtApps = true;

  postInstall = ''
    # causes cyclic dependency but is not used
    rm $out/share/ndk-modules/Android.mk
  '';

  meta = with lib; {
    description = "Qt5/Qt6 library to write cross-platform clients for Matrix";
    homepage = "https://quotient-im.github.io/libQuotient/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
