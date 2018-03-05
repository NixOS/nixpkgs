{ stdenv, fetchurl, fetchpatch, pkgconfig, gettext, perl
, expat, glib, cairo, pango, gdk_pixbuf, atk, at-spi2-atk, gobjectIntrospection
, xorg, epoxy, json-glib, libxkbcommon, gmp
, waylandSupport ? stdenv.isLinux, wayland, wayland-protocols
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux, cups ? null
, darwin, gnome3
}:

assert cupsSupport -> cups != null;

with stdenv.lib;

let
  version = "3.22.26";
in
stdenv.mkDerivation rec {
  name = "gtk+3-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${gnome3.versionBranch version}/gtk+-${version}.tar.xz";
    sha256 = "61eef0d320e541976e2dfe445729f12b5ade53050ee9de6184235cb60cd4b967";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig gettext gobjectIntrospection perl ];

  patches = [
    ./3.0-immodules.cache.patch
    (fetchpatch {
      name = "Xft-setting-fallback-compute-DPI-properly.patch";
      url = "https://bug757142.bugzilla-attachments.gnome.org/attachment.cgi?id=344123";
      sha256 = "0g6fhqcv8spfy3mfmxpyji93k8d4p4q4fz1v9a1c1cgcwkz41d7p";
    })
  ];

  buildInputs = [ libxkbcommon epoxy json-glib ];
  propagatedBuildInputs = with xorg; with stdenv.lib;
    [ expat glib cairo pango gdk_pixbuf atk at-spi2-atk gnome3.gsettings-desktop-schemas
      libXrandr libXrender libXcomposite libXi libXcursor libSM libICE ]
    ++ optionals waylandSupport [ wayland wayland-protocols ]
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit Cocoa ])
    ++ optional xineramaSupport libXinerama
    ++ optional cupsSupport cups;
  #TODO: colord?

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-lintl";

  # demos fail to install, no idea where's the problem
  preConfigure = "sed '/^SRC_SUBDIRS /s/demos//' -i Makefile.in";

  enableParallelBuilding = true;

  configureFlags = optional stdenv.isDarwin [
    "--disable-debug"
    "--disable-dependency-tracking"
    "--disable-glibtest"
    "--with-gdktarget=quartz"
    "--enable-quartz-backend"
  ] ++ optional stdenv.isLinux [
    "--enable-x11-backend"
  ] ++ optional waylandSupport [
    "--enable-wayland-backend"
  ];

  postInstall = optionalString (!stdenv.isDarwin) ''
    substituteInPlace "$out/lib/gtk-3.0/3.0.0/printbackends/libprintbackend-cups.la" \
      --replace '-L${gmp.dev}/lib' '-L${gmp.out}/lib'
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk-update-icon-cache "$out"
    # Launcher
    moveToOutput bin/gtk-launch "$out"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtk+";
      attrPath = "gtk3";
    };
  };

  meta = with stdenv.lib; {
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
