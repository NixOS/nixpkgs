{ stdenv, lib, fetchFromGitHub, cmake, olm, openssl, qtbase, qtmultimedia, qtkeychain }:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in stdenv.mkDerivation rec {
  pname = "libquotient";
  version = "0.8.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    hash = "sha256-6sR/80r9qW9kMYqIi2FeXgb6M795XKzpvyE6eTaBsjA=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ qtbase qtkeychain olm openssl qtmultimedia ];

  cmakeFlags = [
    "-DQuotient_ENABLE_E2EE=ON"
    (lib.cmakeBool "BUILD_WITH_QT6" isQt6)
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
    description = "A Qt5/Qt6 library to write cross-platform clients for Matrix";
    homepage = "https://quotient-im.github.io/libQuotient/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ colemickens matthiasbeyer ];
  };
}
