{ autoreconfHook, cinnamon-desktop, fetchFromGitHub, glib, gnome3, gnome-doc-utils, fetchpatch, gobjectIntrospection, gtk3, intltool, json-glib, libinput, libstartup_notification, libxkbcommon, libXtst, pkgconfig, stdenv, udev, xorg, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "muffin";
    rev = "${version}";
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
      sha256 = "7afedb246946b64ffa5c26cebc4c01dcbf06fe9989d4894d9f588b78f8ef3853";
    })
  ];

  buildInputs = [ cinnamon-desktop glib gobjectIntrospection gtk3 gnome3.zenity gnome-doc-utils intltool json-glib libinput libstartup_notification libxkbcommon libXtst pkgconfig udev xorg.xkeyboardconfig xorg.libxkbfile ];
  nativeBuildInputs = [ autoreconfHook wrapGAppsHook ];

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    # description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
