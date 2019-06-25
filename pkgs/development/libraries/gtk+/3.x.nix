{ stdenv
, fetchurl
, fetchpatch
, pkgconfig
, gettext
, perl
, makeWrapper
, shared-mime-info
, isocodes
, expat
, glib
, cairo
, pango
, gdk_pixbuf
, atk
, at-spi2-atk
, gobject-introspection
, fribidi
, xorg
, epoxy
, json-glib
, libxkbcommon
, gmp
, gnome3
, autoreconfHook
, gsettings-desktop-schemas
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux
, mesa
, wayland
, wayland-protocols
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux
, cups ? null
, AppKit
, Cocoa
}:

assert cupsSupport -> cups != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gtk+3";
  version = "3.24.8";

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${stdenv.lib.versions.majorMinor version}/gtk+-${version}.tar.xz";
    sha256 = "16f71bbkhwhndcsrpyhjia3b77cb5ksf5c45lyfgws4pkgg64sb6";
  };

  patches = [
    ./3.0-immodules.cache.patch
    (fetchpatch {
      name = "Xft-setting-fallback-compute-DPI-properly.patch";
      url = "https://bug757142.bugzilla-attachments.gnome.org/attachment.cgi?id=344123";
      sha256 = "0g6fhqcv8spfy3mfmxpyji93k8d4p4q4fz1v9a1c1cgcwkz41d7p";
    })
  ] ++ optionals stdenv.isDarwin [
    # X11 module requires <gio/gdesktopappinfo.h> which is not installed on Darwin
    # let’s drop that dependency in similar way to how other parts of the library do it
    # e.g. https://gitlab.gnome.org/GNOME/gtk/blob/3.24.4/gtk/gtk-launch.c#L31-33
    ./3.0-darwin-x11.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gobject-introspection
    makeWrapper
    perl
    pkgconfig
  ];

  buildInputs = [
    libxkbcommon
    epoxy
    json-glib
    isocodes
  ]
  ++ optional stdenv.isDarwin AppKit
  ;

  propagatedBuildInputs = with xorg; [
    at-spi2-atk
    atk
    cairo
    expat
    fribidi
    gdk_pixbuf
    glib
    gsettings-desktop-schemas
    libICE
    libSM
    libXcomposite
    libXcursor
    libXi
    libXrandr
    libXrender
    pango
  ]
  ++ optional stdenv.isDarwin Cocoa  # explicitly propagated, always needed
  ++ optionals waylandSupport [ mesa wayland wayland-protocols ]
  ++ optional xineramaSupport libXinerama
  ++ optional cupsSupport cups
  ;
  #TODO: colord?

  ## (2019-06-12) Demos seem to install fine now. Keeping this around in case it fails again.
  ## (2014-03-27) demos fail to install, no idea where's the problem
  #preConfigure = "sed '/^SRC_SUBDIRS /s/demos//' -i Makefile.in";

  configureFlags = optional stdenv.isDarwin [
    "--disable-debug"
    "--disable-dependency-tracking"
    "--disable-glibtest"
  ] ++ optional (stdenv.isDarwin && !x11Support)
    "--enable-quartz-backend"
    ++ optional x11Support [
    "--enable-x11-backend"
  ] ++ optional waylandSupport [
    "--enable-wayland-backend"
  ];

  doCheck = false; # needs X11

  postInstall = optionalString (!stdenv.isDarwin) ''
    substituteInPlace "$out/lib/gtk-3.0/3.0.0/printbackends/libprintbackend-cups.la" \
      --replace '-L${gmp.dev}/lib' '-L${gmp.out}/lib'
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk-update-icon-cache "$out"
    # Launcher
    moveToOutput bin/gtk-launch "$out"

    # TODO: patch glib directly
    for f in $dev/bin/gtk-encode-symbolic-svg; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtk+";
      attrPath = "gtk3";
    };
  };

  meta = {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    longDescription = ''
      GTK+ is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK+ it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK+ is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK+ without any license fees or
      royalties.
    '';
    homepage = https://www.gtk.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin vcunat lethalman ];
    platforms = platforms.all;
  };
}
