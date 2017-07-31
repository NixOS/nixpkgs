{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, libiconv, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, withData ? true, poppler_data
, qt4Support ? false, qt4 ? null
, qt5Support ? false, qtbase ? null
, introspectionSupport ? false, gobjectIntrospection ? null
, utils ? false
, minimal ? false, suffix ? "glib"
, hostPlatform
}:

let # beware: updates often break cups-filters build
  version = "0.56.0";
  sha256 = "0wviayidfv2ix2ql0d4nl9r1ia6qi5kc1nybd9vjx27dk7gvm7c6";
in
stdenv.mkDerivation rec {
  name = "poppler-${suffix}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    inherit sha256;
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libiconv ] ++ libintlOrEmpty ++ lib.optional withData poppler_data;

  # TODO: reduce propagation to necessary libs
  propagatedBuildInputs = with lib;
    [ zlib freetype fontconfig libjpeg openjpeg ]
    ++ optionals (!minimal) [ cairo lcms curl ]
    ++ optional qt4Support qt4
    ++ optional qt5Support qtbase
    ++ optional introspectionSupport gobjectIntrospection;

  nativeBuildInputs = [ pkgconfig ];

  NIX_CFLAGS_COMPILE = [ "-DQT_NO_DEBUG" ];

  CXXFLAGS = lib.optional qt5Support "-std=c++11";

  configureFlags = with lib;
    [
      "--enable-xpdf-headers"
      "--enable-libcurl"
      "--enable-zlib"
      "--enable-build-type=release"
    ]
    ++ optionals minimal [
      "--disable-poppler-glib" "--disable-poppler-cpp"
      "--disable-libcurl"
    ]
    ++ optional (!utils) "--disable-utils"
    ++ optional introspectionSupport "--enable-introspection";

  enableParallelBuilding = true;

  crossAttrs.postPatch =
    # there are tests using `strXXX_s` functions that are missing apparently
    stdenv.lib.optionalString (hostPlatform.libc or null == "msvcrt")
      "sed '/^SUBDIRS =/s/ test / /' -i Makefile.in";

  meta = with lib; {
    homepage = http://poppler.freedesktop.org/;
    description = "A PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
