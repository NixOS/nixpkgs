{ lib, stdenv, fetchurl, fetchpatch, pkg-config, libGL, glib, gdk-pixbuf, xorg, libintl
, pangoSupport ? true, pango, cairo, gobject-introspection, wayland, gnome
, mesa, automake, autoconf
, gstreamerSupport ? true, gst_all_1 }:

stdenv.mkDerivation rec {
  pname = "cogl";
  version = "1.22.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/cogl-${version}.tar.xz";
    sha256 = "0nfph4ai60ncdx7hy6hl1i1cmp761jgnyjfhagzi0iqq36qb41d8";
  };

  patches = [
    # Some deepin packages need the following patches. They have been
    # submitted by Fedora on the GNOME Bugzilla
    # (https://bugzilla.gnome.org/787443). Upstream thinks the patch
    # could be merged, but dev can not make a new release.

    (fetchpatch {
      url = "https://bug787443.bugzilla-attachments.gnome.org/attachment.cgi?id=359589";
      sha256 = "0f0d9iddg8zwy853phh7swikg4yzhxxv71fcag36f8gis0j5p998";
    })

    (fetchpatch {
      url = "https://bug787443.bugzilla-attachments.gnome.org/attachment.cgi?id=361056";
      sha256 = "09fyrdci4727fg6qm5aaapsbv71sf4wgfaqz8jqlyy61dibgg490";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config libintl automake autoconf ];

  configureFlags = [
    "--enable-introspection"
    "--enable-kms-egl-platform"
    "--enable-wayland-egl-platform"
    "--enable-wayland-egl-server"
  ] ++ lib.optional gstreamerSupport "--enable-cogl-gst"
  ++ lib.optionals (!stdenv.isDarwin) [ "--enable-gles1" "--enable-gles2" ];

  propagatedBuildInputs = with xorg; [
      glib gdk-pixbuf gobject-introspection wayland mesa
      libGL libXrandr libXfixes libXcomposite libXdamage
    ]
    ++ lib.optionals gstreamerSupport [ gst_all_1.gstreamer
                                               gst_all_1.gst-plugins-base ];

  buildInputs = lib.optionals pangoSupport [ pango cairo ];

  COGL_PANGO_DEP_CFLAGS
    = lib.optionalString (stdenv.isDarwin && pangoSupport)
      "-I${pango.dev}/include/pango-1.0 -I${cairo.dev}/include/cairo";

  #doCheck = true; # all tests fail (no idea why)

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A small open source library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      Cogl is a small open source library for using 3D graphics hardware for
      rendering. The API departs from the flat state machine style of OpenGL
      and is designed to make it easy to write orthogonal components that can
      render without stepping on each other's toes.
    '';

    platforms = platforms.mesaPlatforms;
    license = with licenses; [ mit bsd3 publicDomain sgi-b-20 ];
  };
}
