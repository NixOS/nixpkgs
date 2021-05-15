{ stdenv, lib, fetchurl, fetchpatch, cmake, ninja, pkg-config, libiconv, libintl
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, withData ? true, poppler_data
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobject-introspection ? null
, utils ? false, nss ? null
, minimal ? false, suffix ? "glib"
}:

let
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";
in
stdenv.mkDerivation (rec {
  name = "poppler-${suffix}-${version}";
  version = "21.02.0"; # beware: updates often break cups-filters build, check texlive and scribusUnstable too!

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    sha256 = "sha256-XBR1nJmJHm5HKs7W1fD/Haz4XYDNkCbTZcVcZT7feSw=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libiconv libintl ] ++ lib.optional withData poppler_data;

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = with lib;
    [ zlib freetype fontconfig libjpeg openjpeg ]
    ++ optionals (!minimal) [ cairo lcms curl ]
    ++ optional qt5Support qtbase
    ++ optional utils nss
    ++ optional introspectionSupport gobject-introspection;

  nativeBuildInputs = [ cmake ninja pkg-config ];

  # Workaround #54606
  preConfigure = lib.optionalString stdenv.isDarwin ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  dontWrapQtApps = true;

  cmakeFlags = [
    (mkFlag true "UNSTABLE_API_ABI_HEADERS") # previously "XPDF_HEADERS"
    (mkFlag (!minimal) "GLIB")
    (mkFlag (!minimal) "CPP")
    (mkFlag (!minimal) "LIBCURL")
    (mkFlag utils "UTILS")
    (mkFlag qt5Support "QT5")
  ];

  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "A PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code
      base. In addition it provides a number of tools that can be
      installed separately.
    '';

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ] ++ teams.freedesktop.members;
  };
} // lib.optionalAttrs stdenv.isDarwin {
  patches = [
    # Fix build due to improperly used volatile in poppler-glib.
    # https://gitlab.freedesktop.org/poppler/poppler/merge_requests/836
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/poppler/poppler/commit/47de887d7658cfd68df44b3acf710971054f957b.patch";
      sha256 = "uvYibBn2fOEqdotxK0Wpf8KhGYZXrpHdmS4jjlRNCj8=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/poppler/poppler/commit/bdd110b45a38e8a4f80f522892e4c4a9e432abd5.patch";
      sha256 = "WDUYXX6v5zk7tusz7DGBP58yFzgEvoBlNSLbfk7+QTc=";
    })
  ];
})
