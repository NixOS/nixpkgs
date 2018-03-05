{ stdenv, hostPlatform, fetchurl, pkgconfig, gettext, perl, python
, libiconv, libintlOrEmpty, zlib, libffi, pcre, libelf, gnome3
# use utillinuxMinimal to avoid circular dependency (utillinux, systemd, glib)
, utillinuxMinimal ? null

# this is just for tests (not in closure of any regular package)
, coreutils, dbus_daemon, libxml2, tzdata, desktop-file-utils, shared-mime-info, doCheck ? false
}:

with stdenv.lib;

assert stdenv.isFreeBSD || stdenv.isDarwin || stdenv.cc.isGNU || hostPlatform.isCygwin;
assert stdenv.isLinux -> utillinuxMinimal != null;

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

  version = "2.54.3";
in

stdenv.mkDerivation rec {
  name = "glib-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "963fdc6685dc3da8e5381dfb9f15ca4b5709b28be84d9d05a9bb8e446abac0a8";
  };

  patches = optional stdenv.isDarwin ./darwin-compilation.patch
    ++ optional doCheck ./skip-timer-test.patch
    ++ [ ./schema-override-variable.patch ];

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  setupHook = ./setup-hook.sh;

  buildInputs = [ libelf setupHook pcre ]
    ++ optionals stdenv.isLinux [ utillinuxMinimal ] # for libmount
    ++ optionals doCheck [ tzdata libxml2 desktop-file-utils shared-mime-info ];

  nativeBuildInputs = [ pkgconfig gettext perl python ];

  propagatedBuildInputs = [ zlib libffi libiconv ]
    ++ libintlOrEmpty;

  # internal pcre would only add <200kB, but it's relatively common
  configureFlags = [ "--with-pcre=system" ]
    ++ optional stdenv.isDarwin "--disable-compile-warnings"
    # glibc inclues GNU libiconv, but Darwin's iconv function is good enonugh.
    ++ optional (stdenv.hostPlatform.libc != "glibc" && !stdenv.hostPlatform.isDarwin)
      "--with-libiconv=gnu"
    ++ optional stdenv.isSunOS "--disable-dtrace"
    # Can't run this test when cross-compiling
    ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform)
       [ "glib_cv_stack_grows=no" "glib_cv_uscore=no" ]
    # GElf only supports elf64 hosts
    ++ optional (!stdenv.hostPlatform.is64bit) "--disable-libelf";

  NIX_CFLAGS_COMPILE = optional stdenv.isDarwin "-lintl"
    ++ optional stdenv.isSunOS "-DBSD_COMP";

  preConfigure = optionalString stdenv.isSunOS ''
    sed -i -e 's|inotify.h|foobar-inotify.h|g' configure
  '';

  postConfigure = ''
    patchShebangs ./gobject/
  '';

  LIBELF_CFLAGS = optional stdenv.isFreeBSD "-I${libelf}";
  LIBELF_LIBS = optional stdenv.isFreeBSD "-L${libelf} -lelf";

  preBuild = optionalString stdenv.isDarwin ''
    export MACOSX_DEPLOYMENT_TARGET=
  '';

  enableParallelBuilding = true;
  DETERMINISTIC_BUILD = 1;

  postInstall = ''
    moveToOutput "share/glib-2.0" "$dev"
    substituteInPlace "$dev/bin/gdbus-codegen" --replace "$out" "$dev"
    sed -i "$dev/bin/glib-gettextize" -e "s|^gettext_dir=.*|gettext_dir=$dev/share/glib-2.0/gettext|"
  ''
  # This file is *included* in gtk3 and would introduce runtime reference via __FILE__.
  + ''
    sed '1i#line 1 "${name}/include/glib-2.0/gobject/gobjectnotifyqueue.c"' \
      -i "$dev"/include/glib-2.0/gobject/gobjectnotifyqueue.c
  '';

  inherit doCheck;
  preCheck = optionalString doCheck ''
    export LD_LIBRARY_PATH="$NIX_BUILD_TOP/${name}/glib/.libs:$LD_LIBRARY_PATH"
    export TZDIR="${tzdata}/share/zoneinfo"
    export XDG_CACHE_HOME="$TMP"
    export XDG_RUNTIME_HOME="$TMP"
    export HOME="$TMP"
    export XDG_DATA_DIRS="${desktop-file-utils}/share:${shared-mime-info}/share"
    export G_TEST_DBUS_DAEMON="${dbus_daemon.out}/bin/dbus-daemon"
    export PATH="$PATH:$(pwd)/gobject"
    echo "PATH=$PATH"

    substituteInPlace gio/tests/desktop-files/home/applications/epiphany-weather-for-toronto-island-9c6a4e022b17686306243dada811d550d25eb1fb.desktop \
      --replace "Exec=/bin/true" "Exec=${coreutils}/bin/true"
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
    updateScript = gnome3.updateScript { packageName = "glib"; };
  };

  meta = with stdenv.lib; {
    description = "C library of programming buildings blocks";
    homepage    = https://www.gtk.org/;
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.unix;

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';
  };
}
