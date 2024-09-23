{ config
, lib
, stdenv
, fetchurl
, fetchpatch
, atk
, buildPackages
, cairo
, cups
, gdk-pixbuf
, gettext
, glib
, gobject-introspection
, libXcomposite
, libXcursor
, libXdamage
, libXi
, libXinerama
, libXrandr
, libXrender
, pango
, perl
, pkg-config
, substituteAll
, testers
, AppKit
, Cocoa
, gdktarget ? if stdenv.isDarwin then "quartz" else "x11"
, cupsSupport ? config.gtk2.cups or stdenv.isLinux
, xineramaSupport ? stdenv.isLinux
}:

let
  gtkCleanImmodulesCache = substituteAll {
    src = ./hooks/clean-immodules-cache.sh;
    gtk_module_path = "gtk-2.0";
    gtk_binary_version = "2.10.0";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gtk+";
  version = "2.24.33";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/gtk+-${finalAttrs.version}.tar.xz";
    hash = "sha256-rCrHV/WULTGKMRpUsMgLXvKV8pnCpzxjL2v7H/Scxto=";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  setupHooks =  [
    ./hooks/drop-icon-theme-cache.sh
    gtkCleanImmodulesCache
  ];

  nativeBuildInputs = finalAttrs.setupHooks ++ [
    gettext
    gobject-introspection
    perl
    pkg-config
  ];

  patches = [
    ./patches/2.0-immodules.cache.patch
    ./patches/gtk2-theme-paths.patch
    (fetchpatch {
      # https://gitlab.gnome.org/GNOME/gtk/-/issues/6786
      name = "CVE-2024-6655.patch";
      url = "https://gitlab.gnome.org/GNOME/gtk/-/commit/3bbf0b6176d42836d23c36a6ac410e807ec0a7a7.patch";
      hash = "sha256-mstOPk9NNpUwScrdEbvGhmAv8jlds3SBdj53T0q33vM=";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    ./patches/2.0-gnome_bugzilla_557780_306776_freeciv_darwin.patch
    ./patches/2.0-darwin-x11.patch
    # Fixes an incompatible function pointer conversion and implicit int errors with clang 16.
    ./patches/2.0-clang.patch
  ];

  propagatedBuildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    pango
  ] ++ lib.optionals (stdenv.isLinux || stdenv.isDarwin) [
    libXcomposite
    libXcursor
    libXi
    libXrandr
    libXrender
  ] ++ lib.optional xineramaSupport libXinerama
  ++ lib.optional cupsSupport cups
  ++ lib.optionals stdenv.isDarwin [
    libXdamage
    AppKit
    Cocoa
  ];

  preConfigure =
    lib.optionalString (stdenv.isDarwin
                        && lib.versionAtLeast
                          stdenv.hostPlatform.darwinMinVersion "11")
      "MACOSX_DEPLOYMENT_TARGET=10.16";

  configureFlags = [
    "--sysconfdir=/etc"
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

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
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
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://www.gtk.org/";
    description = "Multi-platform toolkit for creating graphical user interfaces";
    longDescription = ''
      GTK is a highly usable, feature rich toolkit for creating graphical user
      interfaces which boasts cross platform compatibility and an easy to use
      API.  GTK it is written in C, but has bindings to many other popular
      programming languages such as C++, Python and C# among others.  GTK is
      licensed under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK without any license fees or royalties.
    '';
    changelog = "https://gitlab.gnome.org/GNOME/gtk/-/raw/${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lovek323 raskin ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "gdk-2.0"
      "gtk+-2.0"
    ] ++ lib.optionals (gdktarget == "x11") [
      "gdk-x11-2.0"
      "gtk+-x11-2.0"
    ];
  };
})
