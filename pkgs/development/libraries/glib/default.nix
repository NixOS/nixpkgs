{ stdenv, fetchurl, pkgconfig, gettext, perl, python
, libiconv, libintlOrEmpty, zlib, libffi, pcre, libelf

# this is just for tests (not in closure of any regular package)
, coreutils, dbus_daemon, libxml2, tzdata, desktop_file_utils, shared_mime_info, doCheck ? false
}:

with stdenv.lib;

assert stdenv.isFreeBSD || stdenv.isDarwin || stdenv.cc.isGNU;

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved
/*
  * Use --enable-installed-tests for GNOME-related packages,
      and use them as a separately installed tests runned by Hydra
      (they should test an already installed package)
      https://wiki.gnome.org/GnomeGoals/InstalledTests
  * Support org.freedesktop.Application, including D-Bus activation from desktop files
*/
let
  # Some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>.
  # This is intended to be run in postInstall of any package
  # which has $out/include/ containing just some disjunct directories.
  flattenInclude = ''
    for dir in "''${!outputInclude}"/include/*; do
      cp -r "$dir"/* "''${!outputInclude}/include/"
      rm -r "$dir"
      ln -s . "$dir"
    done
    ln -sr -t "''${!outputInclude}/include/" "''${!outputInclude}"/lib/*/include/* 2>/dev/null || true
  '';

  ver_maj = "2.48";
  ver_min = "0";
in

stdenv.mkDerivation rec {
  name = "glib-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${ver_maj}/${name}.tar.xz";
    sha256 = "0d3w2hblrw7vvpx60l1kbvb830ygn3v8zhwdz65cc5593j9ycjvl";
  };

  patches = optional stdenv.isDarwin ./darwin-compilation.patch ++ optional doCheck ./skip-timer-test.patch;

  outputs = [ "dev" "out" "docdev" ];
  outputBin = "dev";

  setupHook = ./setup-hook.sh;

  buildInputs = [ libelf setupHook ]
    ++ optionals doCheck [ tzdata libxml2 desktop_file_utils shared_mime_info ];

  nativeBuildInputs = [ pkgconfig gettext perl python ];

  propagatedBuildInputs = [ zlib libffi libiconv pcre ]
    ++ libintlOrEmpty;

  # internal pcre would only add <200kB, but it's relatively common
  configureFlags = [ "--with-pcre=system" ]
    ++ optional stdenv.isDarwin "--disable-compile-warnings"
    ++ optional (stdenv.isFreeBSD || stdenv.isSunOS) "--with-libiconv=gnu"
    ++ optional stdenv.isSunOS "--disable-dtrace";

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin " -lintl"
    + optionalString stdenv.isSunOS " -DBSD_COMP";

  preConfigure = if !stdenv.isSunOS then null else
    ''
      sed -i -e 's|inotify.h|foobar-inotify.h|g' configure
    '';

  LIBELF_CFLAGS = optional stdenv.isFreeBSD "-I${libelf}";
  LIBELF_LIBS = optional stdenv.isFreeBSD "-L${libelf} -lelf";

  preBuild = optionalString stdenv.isDarwin
    ''
      export MACOSX_DEPLOYMENT_TARGET=
    '';

  enableParallelBuilding = true;
  DETERMINISTIC_BUILD = 1;

  postInstall = ''
    moveToOutput "share/glib-2.0" "$dev"
    substituteInPlace "$dev/bin/gdbus-codegen" --replace "$out" "$dev"
    sed -i "$dev/bin/glib-gettextize" -e "s|^gettext_dir=.*|gettext_dir=$dev/share/glib-2.0/gettext|"
  '';

  inherit doCheck;
  preCheck = optionalString doCheck
    '' export LD_LIBRARY_PATH="$NIX_BUILD_TOP/${name}/glib/.libs:$LD_LIBRARY_PATH"
       export TZDIR="${tzdata}/share/zoneinfo"
       export XDG_CACHE_HOME="$TMP"
       export XDG_RUNTIME_HOME="$TMP"
       export HOME="$TMP"
       export XDG_DATA_DIRS="${desktop_file_utils}/share:${shared_mime_info}/share"
       export G_TEST_DBUS_DAEMON="${dbus_daemon.out}/bin/dbus-daemon"

       substituteInPlace gio/tests/desktop-files/home/applications/epiphany-weather-for-toronto-island-9c6a4e022b17686306243dada811d550d25eb1fb.desktop --replace "Exec=/bin/true" "Exec=${coreutils}/bin/true"
       # Needs machine-id, comment the test
       sed -e '/\/gdbus\/codegen-peer-to-peer/ s/^\/*/\/\//' -i gio/tests/gdbus-peer.c
       sed -e '/g_test_add_func/ s/^\/*/\/\//' -i gio/tests/gdbus-unix-addresses.c
       # All gschemas fail to pass the test, upstream bug?
       sed -e '/g_test_add_data_func/ s/^\/*/\/\//' -i gio/tests/gschema-compile.c
       # Cannot reproduce the failing test_associations on hydra
       sed -e '/\/appinfo\/associations/d' -i gio/tests/appinfo.c
       # Needed because of libtool wrappers
       sed -e '/g_subprocess_launcher_set_environ (launcher, envp);/a g_subprocess_launcher_setenv (launcher, "PATH", g_getenv("PATH"), TRUE);' -i gio/tests/gsubprocess.c
    '';

  passthru = {
     gioModuleDir = "lib/gio/modules";
     inherit flattenInclude;
  };

  meta = with stdenv.lib; {
    description = "C library of programming buildings blocks";
    homepage    = http://www.gtk.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 raskin urkud ];
    platforms   = platforms.unix;

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';
  };
}
