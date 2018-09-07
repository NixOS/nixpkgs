{ stdenv, fetchurl, pkgconfig, gettext, glib, atk, pango, cairo, perl, xorg
, gdk_pixbuf, xlibsWrapper, gobjectIntrospection
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? true, cups ? null
, gdktarget ? if stdenv.isDarwin then "quartz" else "x11"
, AppKit, Cocoa
, fetchpatch
}:

assert xineramaSupport -> xorg.libXinerama != null;
assert cupsSupport -> cups != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gtk+-2.24.32";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${name}.tar.xz";
    sha256 = "b6c8a93ddda5eabe3bfee1eb39636c9a03d2a56c7b62828b359bf197943c582e";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ setupHook perl pkgconfig gettext gobjectIntrospection ];

  patches = [
    ./2.0-immodules.cache.patch
    ./gtk2-theme-paths.patch
  ] ++ optional stdenv.isDarwin (fetchpatch {
    url = https://bug557780.bugzilla-attachments.gnome.org/attachment.cgi?id=306776;
    sha256 = "0sp8f1r5c4j2nlnbqgv7s7nxa4cfwigvm033hvhb1ld652pjag4r";
  });

  propagatedBuildInputs = with xorg;
    [ glib cairo pango gdk_pixbuf atk ]
    ++ optionals (stdenv.isLinux || stdenv.isDarwin) [
         libXrandr libXrender libXcomposite libXi libXcursor
       ]
    ++ optionals stdenv.isDarwin [ xlibsWrapper libXdamage ]
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

  doCheck = false; # needs X11

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
    homepage    = https://www.gtk.org/;
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
