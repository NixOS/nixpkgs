{ lib
, stdenv
, fetchurl
, fetchFromGitLab
, cairo
, cmake
, boost
, cups-filters
, curl
, fontconfig
, freetype
, inkscape
, lcms
, libiconv
, libintl
, libjpeg
, ninja
, openjpeg
, pkg-config
, python3
, scribus
, zlib
, withData ? true, poppler_data
, qt5Support ? false, qt6Support ? false, qtbase ? null
, introspectionSupport ? false, gobject-introspection ? null
, gpgmeSupport ? false, gpgme ? null
, utils ? false, nss ? null
, minimal ? false
, suffix ? "glib"
}:

let
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";

  # unclear relationship between test data repo versions and poppler
  # versions, though files don't appear to be updated after they're
  # added, so it's probably safe to just always use the latest available
  # version.
  testData = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "poppler";
    repo = "test";
    rev = "e3cdc82782941a8d7b8112f83b4a81b3d334601a";
    hash = "sha256-i/NjVWC/PXAXnv88qNaHFBQQNEjRgjdV224NgENaESo=";
  };
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "poppler-${suffix}";
  version = "23.11.0"; # beware: updates often break cups-filters build, check scribus too!

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-${version}.tar.xz";
    hash = "sha256-+ZzKZ5nLnLbJL8Hg63hUe2EctzN1CrfLBHyw5sJGU5w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    boost
    libiconv
    libintl
  ] ++ lib.optionals withData [
    poppler_data
  ];

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = [
    zlib
    freetype
    fontconfig
    libjpeg
    openjpeg
  ] ++ lib.optionals (!minimal) [
    cairo
    lcms
    curl
    nss
  ] ++ lib.optionals (qt5Support || qt6Support) [
    qtbase
  ] ++ lib.optionals introspectionSupport [
    gobject-introspection
  ] ++ lib.optionals gpgmeSupport [
    gpgme
  ];

  cmakeFlags = [
    (mkFlag true "UNSTABLE_API_ABI_HEADERS") # previously "XPDF_HEADERS"
    (mkFlag (!minimal) "GLIB")
    (mkFlag (!minimal) "CPP")
    (mkFlag (!minimal) "LIBCURL")
    (mkFlag (!minimal) "LCMS")
    (mkFlag (!minimal) "LIBTIFF")
    (mkFlag (!minimal) "NSS3")
    (mkFlag utils "UTILS")
    (mkFlag qt5Support "QT5")
    (mkFlag qt6Support "QT6")
    (mkFlag gpgmeSupport "GPGME")
  ] ++ lib.optionals finalAttrs.finalPackage.doCheck [
    "-DTESTDATADIR=${testData}"
  ];
  disallowedReferences = lib.optional finalAttrs.finalPackage.doCheck testData;

  dontWrapQtApps = true;

  # Workaround #54606
  preConfigure = lib.optionalString stdenv.isDarwin ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  # Work around gpgme trying to write to $HOME during qt5 and qt6 tests:
  preCheck = lib.optionalString gpgmeSupport ''
    HOME_orig="$HOME"
    export HOME="$(mktemp -d)"
  '';

  postCheck = lib.optionalString gpgmeSupport ''
    export HOME="$HOME_orig"
    unset -v HOME_orig
  '';

  doCheck = true;

  passthru = {
    inherit testData;
    tests = {
      # These depend on internal poppler code that frequently changes.
      inherit inkscape cups-filters scribus;
    };
  };

  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "A PDF rendering library";
    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base. In
      addition it provides a number of tools that can be installed separately.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ] ++ teams.freedesktop.members;
  };
})
