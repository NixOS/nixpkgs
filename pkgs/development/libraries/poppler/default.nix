{ lib
, stdenv
, fetchurl
, fetchpatch
, cairo
, cmake
, pcre
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
, texlive
, zlib
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobject-introspection ? null
, utils ? false, nss ? null
, minimal ? false
, suffix ? "glib"
}:

let
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";
in
stdenv.mkDerivation rec {
  pname = "poppler-${suffix}";
  version = "22.06.0"; # beware: updates often break cups-filters build, check texlive and scribus too!

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-${version}.tar.xz";
    sha256 = "sha256-oPmqo5GLrXgQOfwwemNWUqFNGzkc1Vm2bt7Evtujxdc=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-38784.patch";
      url = "https://gitlab.freedesktop.org/poppler/poppler/-/commit/27354e9d9696ee2bc063910a6c9a6b27c5184a52.patch";
      sha256 = "sha256-M12zaHxcgQB/37tHffllqzd+Juq9BH5gpKVGaRY00vI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    boost
    pcre
    libiconv
    libintl
  ] ++ lib.optional withData [
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
  ] ++ lib.optionals qt5Support [
    qtbase
  ] ++ lib.optionals introspectionSupport [
    gobject-introspection
  ];

  cmakeFlags = [
    (mkFlag true "UNSTABLE_API_ABI_HEADERS") # previously "XPDF_HEADERS"
    (mkFlag (!minimal) "GLIB")
    (mkFlag (!minimal) "CPP")
    (mkFlag (!minimal) "LIBCURL")
    (mkFlag utils "UTILS")
    (mkFlag qt5Support "QT5")
  ];

  dontWrapQtApps = true;

  # Workaround #54606
  preConfigure = lib.optionalString stdenv.isDarwin ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  passthru = {
    tests = {
      # These depend on internal poppler code that frequently changes.
      inherit inkscape cups-filters texlive scribus;
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
}
