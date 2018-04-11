{ stdenv, fetchurl, pkgconfig, libGL, glib, gdk_pixbuf, xorg, libintl
, pangoSupport ? true, pango, cairo, gobjectIntrospection, wayland, gnome3
, mesa_noglu
, gstreamerSupport ? true, gst_all_1 }:

let
  pname = "cogl";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.22.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "03f0ha3qk7ca0nnkkcr1garrm1n1vvfqhkz9lwjm592fnv6ii9rr";
  };

  nativeBuildInputs = [ pkgconfig libintl ];

  configureFlags = [
    "--enable-introspection"
    "--enable-kms-egl-platform"
    "--enable-wayland-egl-platform"
    "--enable-wayland-egl-server"
  ] ++ stdenv.lib.optional gstreamerSupport "--enable-cogl-gst"
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ "--enable-gles1" "--enable-gles2" ];

  propagatedBuildInputs = with xorg; [
      glib gdk_pixbuf gobjectIntrospection wayland mesa_noglu
      libGL libXrandr libXfixes libXcomposite libXdamage
    ]
    ++ stdenv.lib.optionals gstreamerSupport [ gst_all_1.gstreamer
                                               gst_all_1.gst-plugins-base ];

  buildInputs = stdenv.lib.optionals pangoSupport [ pango cairo ];

  COGL_PANGO_DEP_CFLAGS
    = stdenv.lib.optionalString (stdenv.isDarwin && pangoSupport)
      "-I${pango.dev}/include/pango-1.0 -I${cairo.dev}/include/cairo";

  #doCheck = true; # all tests fail (no idea why)

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A small open source library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      Cogl is a small open source library for using 3D graphics hardware for
      rendering. The API departs from the flat state machine style of OpenGL
      and is designed to make it easy to write orthogonal components that can
      render without stepping on each other's toes.
    '';

    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
