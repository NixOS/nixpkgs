{ autoreconfHook, cinnamon-desktop, fetchFromGitHub, glib, gnome3, gnome-doc-utils, fetchpatch, gobject-introspection, gtk3, intltool, json-glib, libinput, libstartup_notification, libxkbcommon, libXtst, pkgconfig, stdenv, udev, xorg, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1aijl08pmjc79g76y0f36b04ia45bszw1r4lsnpjbbi72nabj2v1";
  };

  /* cogl-texture-2d.c:432:43: error: 'EGL_WAYLAND_BUFFER_WL' undeclared (first use in this function); did you mean 'EGL_TRIPLE_BUFFER_NV'?
                                             EGL_WAYLAND_BUFFER_WL,
                                             ^~~~~~~~~~~~~~~~~~~~~
                                             EGL_TRIPLE_BUFFER_NV

  https://bugs.gentoo.org/698736 - Muffin is a mutter fork, so patch _should_ apply  */

  patches = [
    #(fetchpatch { # superseeded by egl.patch
    #  url = "https://698736.bugs.gentoo.org/attachment.cgi?id=594588";
    #  sha256 = "f042267b05bec579da0697e4906048af928093a9b3cddc937c63defde627f2d5";
    #})
    ./egl.patch
    ./disable-docs.patch
    (fetchpatch { # https://github.com/linuxmint/muffin/issues/535#issuecomment-536917143
      url = "https://src.fedoraproject.org/rpms/muffin/blob/master/f/0001-fix-warnings-when-compiling.patch";
      sha256 = "15wdbn3afn3103v7rq1icp8n0vqqwrrya03h0g2rzqlrsc7wrvzw";
    })
  ];

  buildInputs = [ cinnamon-desktop glib gtk3 gnome3.zenity gnome-doc-utils intltool json-glib libinput libstartup_notification libxkbcommon libXtst pkgconfig udev xorg.xkeyboardconfig xorg.libxkbfile ];
  nativeBuildInputs = [ autoreconfHook wrapGAppsHook gobject-introspection ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/muffin";
    description = "The window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
