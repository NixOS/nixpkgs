{
  stdenv,
  lib,
  fetchFromGitHub,
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
    tag = version;
    hash = "sha256-wdIE5LI4l3WUvpGfoJBL8sjBl2k8NfZTh9CjfJc9FIA=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    qtbase
    qtkeychain
    olm
    openssl
    qtmultimedia
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
