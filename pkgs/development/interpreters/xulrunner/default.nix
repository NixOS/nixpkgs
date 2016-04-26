{ lib, stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xorg
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu, firefox
, debugBuild ? false
}:

assert stdenv.cc ? libc && stdenv.cc.libc != null;

let version = firefox.version; in

stdenv.mkDerivation rec {
  name = "xulrunner-${version}";

  src = firefox.src;

  buildInputs =
    [ pkgconfig gtk perl zip libIDL libjpeg zlib bzip2
      python dbus dbus_glib pango freetype fontconfig xorg.libXi
      xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
      alsaLib nspr nss libnotify xorg.pixman yasm mesa
      xorg.libXScrnSaver xorg.scrnsaverproto pysqlite
      xorg.libXext xorg.xextproto /*sqlite*/ unzip makeWrapper
      hunspell libevent libstartup_notification libvpx cairo
      gstreamer gst_plugins_base icu
    ];

  configureFlags =
    [ "--enable-application=xulrunner"
      "--disable-javaxpcom"
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--with-system-nss"
      "--with-system-libevent"
      "--with-system-libvpx"
      # "--with-system-png" # needs APNG support
      # "--with-system-icu" # causes ‘ar: invalid option -- 'L'’ in Firefox 28.0
      "--enable-system-ffi"
      "--enable-system-hunspell"
      "--enable-system-pixman"
      #"--enable-system-sqlite"
      "--enable-system-cairo"
      "--enable-gstreamer"
      "--enable-startup-notification"
      # "--enable-content-sandbox"            # available since 26.0, but not much info available
      # "--enable-content-sandbox-reporter"   # keeping disabled for now
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-installer"
      "--disable-updater"
      "--disable-pulseaudio"
      "--disable-gconf"
    ]
    ++ (if debugBuild
        then [ "--enable-debug" "--enable-profiling"]
        else [ "--disable-debug" "--enable-release" "--enable-strip"
               "--enable-optimize${lib.optionalString (stdenv.system == "i686-linux") "=-O1"}" ]);

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureScript=$(pwd)/configure
      mkdir ../objdir
      cd ../objdir
    '';

  meta = {
    description = "Mozilla Firefox XUL runner";
    homepage = http://www.mozilla.com/en-US/firefox/;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  };

  passthru = { inherit gtk version; };
}
