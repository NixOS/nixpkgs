{ config, lib, substituteAll, stdenv, fetchurl, pkg-config, gettext, glib, atk, pango, cairo, perl, xorg
, gdk-pixbuf, gobject-introspection
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? config.gtk2.cups or stdenv.isLinux, cups
, gdktarget ? if stdenv.isDarwin then "quartz" else "x11"
, AppKit, Cocoa
, fetchpatch, buildPackages
}:

let

  gtkCleanImmodulesCache = substituteAll {
    src = ./hooks/clean-immodules-cache.sh;
    gtk_module_path = "gtk-2.0";
    gtk_binary_version = "2.10.0";
  };

in

stdenv.mkDerivation rec {
  pname = "gtk+";
  version = "2.24.33";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/${pname}-${version}.tar.xz";
    sha256 = "rCrHV/WULTGKMRpUsMgLXvKV8pnCpzxjL2v7H/Scxto=";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  enableParallelBuilding = true;

  setupHooks =  [
    ./hooks/drop-icon-theme-cache.sh
    gtkCleanImmodulesCache
  ];


  nativeBuildInputs = setupHooks ++ [ perl pkg-config gettext gobject-introspection ];

  patches = [
    ./patches/2.0-immodules.cache.patch
    ./patches/gtk2-theme-paths.patch
  ] ++ lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://bug557780.bugzilla-attachments.gnome.org/attachment.cgi?id=306776";
      sha256 = "0sp8f1r5c4j2nlnbqgv7s7nxa4cfwigvm033hvhb1ld652pjag4r";
    })
    ./patches/2.0-darwin-x11.patch
  ];

  propagatedBuildInputs = with xorg;
    [ glib cairo pango gdk-pixbuf atk ]
    ++ lib.optionals (stdenv.isLinux || stdenv.isDarwin) [
         libXrandr libXrender libXcomposite libXi libXcursor
       ]
    ++ lib.optionals stdenv.isDarwin [ libXdamage ]
    ++ lib.optional xineramaSupport libXinerama
    ++ lib.optionals cupsSupport [ cups ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Cocoa ];

  preConfigure = if (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) then ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '' else null;

  configureFlags = [
    "--with-gdktarget=${gdktarget}"
    "--with-xinput=yes"
  ] ++ lib.optionals stdenv.isDarwin [
    "--disable-glibtest"
    "--disable-introspection"
    "--disable-visibility"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_path_GTK_UPDATE_ICON_CACHE=${buildPackages.gtk2}/bin/gtk-update-icon-cache"
    "ac_cv_path_GDK_PIXBUF_CSOURCE=${buildPackages.gdk-pixbuf.dev}/bin/gdk-pixbuf-csource"
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

  meta = with lib; {
    description = "A multi-platform toolkit for creating graphical user interfaces";
    homepage    = "https://www.gtk.org/";
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.all;

    longDescription = ''
      GTK is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK without any license fees or
      royalties.
    '';
    changelog = "https://gitlab.gnome.org/GNOME/gtk/-/raw/${version}/NEWS";
  };
}
