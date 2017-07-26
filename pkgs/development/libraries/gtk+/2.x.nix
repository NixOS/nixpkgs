{ stdenv, fetchurl, pkgconfig, gettext, glib, atk, pango, cairo, perl, xorg
, gdk_pixbuf, libintlOrEmpty, xlibsWrapper
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? true, cups ? null
, gdktarget ? "x11"
, AppKit, Cocoa
}:

assert xineramaSupport -> xorg.libXinerama != null;
assert cupsSupport -> cups != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gtk+-2.24.31";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${name}.tar.xz";
    sha256 = "68c1922732c7efc08df4656a5366dcc3afdc8791513400dac276009b40954658";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = optionalString (libintlOrEmpty != []) "-lintl";

  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ setupHook perl pkgconfig gettext ];

  patches = [ ./2.0-immodules.cache.patch ./gtk2-theme-paths.patch ];

  propagatedBuildInputs = with xorg;
    [ glib cairo pango gdk_pixbuf atk ]
    ++ optionals (stdenv.isLinux || stdenv.isDarwin) [
         libXrandr libXrender libXcomposite libXi libXcursor
       ]
    ++ optionals stdenv.isDarwin [ xlibsWrapper libXdamage ]
    ++ libintlOrEmpty
    ++ optional xineramaSupport libXinerama
    ++ optionals cupsSupport [ cups ]
    ++ optionals stdenv.isDarwin [ AppKit Cocoa ];

  configureFlags = [
    "--with-gdktarget=${gdktarget}"
    "--with-xinput=yes"
  ] ++ optionals stdenv.isDarwin [
    "--disable-glibtest"
    "--disable-introspection"
    "--disable-visibility"
  ];

  postInstall = ''
    moveToOutput share/gtk-2.0/demo "$devdoc"
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk-update-icon-cache "$out"
  '';

  passthru = {
    gtkExeEnvPostBuild = ''
      rm $out/lib/gtk-2.0/2.10.0/immodules.cache
      $out/bin/gtk-query-immodules-2.0 $out/lib/gtk-2.0/2.10.0/immodules/*.so > $out/lib/gtk-2.0/2.10.0/immodules.cache
    ''; # workaround for bug of nix-mode for Emacs */ '';
    inherit gdktarget;
  };

  meta = {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    homepage    = http://www.gtk.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.all;

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
  };
}
