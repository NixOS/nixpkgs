{ lib, stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu
, debugBuild ? false
}:

assert stdenv.gcc ? libc && stdenv.gcc.libc != null;

let version = "31.0"; in

stdenv.mkDerivation rec {
  name = "xulrunner-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${version}/source/firefox-${version}.source.tar.bz2";
    sha1 = "a6c3e25ee3aeb7da42db2aaeb50a385d63532beb";
  };

  buildInputs =
    [ pkgconfig gtk perl zip libIDL libjpeg zlib bzip2
      python dbus dbus_glib pango freetype fontconfig xlibs.libXi
      xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
      alsaLib nspr nss libnotify xlibs.pixman yasm mesa
      xlibs.libXScrnSaver xlibs.scrnsaverproto pysqlite
      xlibs.libXext xlibs.xextproto sqlite unzip makeWrapper
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
      "--enable-system-sqlite"
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
    ]
    ++ (if debugBuild then [ "--enable-debug" "--enable-profiling"]
                      else [ "--disable-debug" "--enable-release"
                             "--enable-optimize" "--enable-strip" ]);

  enableParallelBuilding = true;

  preConfigure =
    ''
      mkdir ../objdir
      cd ../objdir
      configureScript=../mozilla-release/configure
    '';

  meta = {
    description = "Mozilla Firefox XUL runner";
    homepage = http://www.mozilla.com/en-US/firefox/;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  };

  passthru = { inherit gtk version; };
}
