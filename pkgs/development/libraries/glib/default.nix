{ config
, lib
, stdenv
, fetchurl
, gettext
, meson
, ninja
, pkg-config
, perl
, python3
, python3Packages
, libiconv, zlib, libffi, pcre2, elfutils, gnome, libselinux, bash, gnum4, libxslt
, docutils, gi-docgen
# use util-linuxMinimal to avoid circular dependency (util-linux, systemd, glib)
, util-linuxMinimal ? null
, buildPackages

# this is just for tests (not in the closure of any regular package)
, dbus, tzdata
, desktop-file-utils, shared-mime-info
, darwin
, makeHardcodeGsettingsPatch
, testers
, gobject-introspection
, libsystemtap
, libsysprof-capture
, mesonEmulatorHook
, withIntrospection ?
  stdenv.hostPlatform.emulatorAvailable buildPackages &&
  lib.meta.availableOn stdenv.hostPlatform gobject-introspection &&
  stdenv.hostPlatform.isLittleEndian == stdenv.buildPlatform.isLittleEndian
}:

assert stdenv.hostPlatform.isLinux -> util-linuxMinimal != null;

let
  # Some packages don't get "Cflags" from pkg-config correctly
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

  gobject-introspection' = buildPackages.gobject-introspection.override {
    propagateFullGlib = false;
    # Avoid introducing cairo, which enables gobjectSupport by default.
    x11Support = false;
  };

  librarySuffix = if (stdenv.hostPlatform.extensions.library == ".so") then "2.0.so.0"
                  else if (stdenv.hostPlatform.extensions.library == ".dylib") then "2.0.0.dylib"
                  else if (stdenv.hostPlatform.extensions.library == ".a") then "2.0.a"
                  else if (stdenv.hostPlatform.extensions.library == ".dll") then "2.0-0.dll"
                  else "2.0-0.lib";

  systemtap' = buildPackages.linuxPackages.systemtap.override { withStap = false; };
  withDtrace =
    lib.meta.availableOn stdenv.buildPlatform systemtap' &&
    # dtrace support requires sys/sdt.h header
    lib.meta.availableOn stdenv.hostPlatform libsystemtap;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "glib";
  version = "2.82.0";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${lib.versions.majorMinor finalAttrs.version}/glib-${finalAttrs.version}.tar.xz";
    hash = "sha256-9Mgq2lE2a92s5J17pUsztOTWBnr6MAjkhH9By5tcONM=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./darwin-compilation.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    ./quark_init_on_demand.patch
    ./gobject_init_on_demand.patch
  ] ++ [
    # This patch lets GLib's GDesktopAppInfo API watch and notice changes
    # to the Nix user and system profiles.  That way, the list of available
    # applications shown by the desktop environment is immediately updated
    # when the user installs or removes any
    # (see <https://issues.guix.gnu.org/35594>).

    # It does so by monitoring /nix/var/nix/profiles (for changes to the system
    # profile) and /nix/var/nix/profiles/per-user/USER (for changes to the user
    # profile) as well as /etc/profiles/per-user (for chanes to the user
    # environment profile) and crawling their share/applications sub-directory when
    # changes happen.
    ./glib-appinfo-watch.patch

    ./schema-override-variable.patch

    # Add support for Pantheon’s terminal emulator.
    ./elementary-terminal-support.patch

    # GLib contains many binaries used for different purposes;
    # we will install them to different outputs:
    # 1. Tools for desktop environment and introspection ($bin)
    #    * gapplication (non-darwin)
    #    * gdbus
    #    * gi-compile-repository
    #    * gi-decompile-typelib
    #    * gi-inspect-typelib
    #    * gio
    #    * gio-launch-desktop (symlink to $out)
    #    * gsettings
    # 2. Development/build tools ($dev)
    #    * gdbus-codegen
    #    * gio-querymodules
    #    * glib-compile-resources
    #    * glib-compile-schemas
    #    * glib-genmarshal
    #    * glib-gettextize
    #    * glib-mkenums
    #    * gobject-query
    #    * gresource
    #    * gtester
    #    * gtester-report
    # 3. Tools for desktop environment that cannot go to $bin due to $out depending on them ($out)
    #    * gio-launch-desktop
    ./split-dev-programs.patch

    # Tell Meson to install gdb scripts next to the lib
    # GDB only looks there and in ${gdb}/share/gdb/auto-load,
    # and by default meson installs in to $out/share/gdb/auto-load
    # which does not help
    ./gdb_script.patch
  ];

  outputs = [ "bin" "out" "dev" "devdoc" ];

  setupHook = ./setup-hook.sh;

  buildInputs = [
    finalAttrs.setupHook
    libsysprof-capture
    pcre2
  ] ++ lib.optionals (!stdenv.hostPlatform.isWindows) [
    bash gnum4 # install glib-gettextize and m4 macros for other apps to use
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [
    elfutils
  ] ++ lib.optionals withDtrace [
    libsystemtap
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libselinux
    util-linuxMinimal # for libmount
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit Carbon Cocoa CoreFoundation CoreServices Foundation
  ]);

  strictDeps = true;

  depsBuildBuild = [
    pkg-config # required to find native gi-docgen
  ];

  nativeBuildInputs = [
    docutils # for rst2man, rst2html5
    meson
    ninja
    pkg-config
    perl
    python3
    python3Packages.packaging # mostly used to make meson happy
    python3Packages.wrapPython # for patchPythonScript
    gettext
    libxslt
  ] ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection'
  ] ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ] ++ lib.optionals withDtrace [
    systemtap' # for dtrace
  ];

  propagatedBuildInputs = [ zlib libffi gettext libiconv ];

  mesonFlags = [
    "-Dglib_debug=disabled" # https://gitlab.gnome.org/GNOME/glib/-/issues/3421#note_2206315
    "-Ddocumentation=true" # gvariant specification can be built without gi-docgen
    (lib.mesonEnable "dtrace" withDtrace)
    (lib.mesonEnable "systemtap" withDtrace) # requires dtrace option to be enabled
    "-Dnls=enabled"
    "-Ddevbindir=${placeholder "dev"}/bin"
    (lib.mesonEnable "introspection" withIntrospection)
    # FIXME: Fails when linking target glib/tests/libconstructor-helper.so
    # relocation R_X86_64_32 against hidden symbol `__TMC_END__' can not be used when making a shared object
    "-Dtests=${lib.boolToString (!stdenv.hostPlatform.isStatic)}"
  ] ++ lib.optionals (!lib.meta.availableOn stdenv.hostPlatform elfutils) [
    "-Dlibelf=disabled"
  ] ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    "-Db_lundef=false"
    "-Dxattr=false"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=nonnull"
    # Default for release buildtype but passed manually because
    # we're using plain
    "-DG_DISABLE_CAST_CHECKS"
  ];

  postPatch = ''
    patchShebangs glib/gen-unicode-tables.pl
    patchShebangs glib/tests/gen-casefold-txt.py
    patchShebangs glib/tests/gen-casemap-txt.py
    patchShebangs tools/gen-visibility-macros.py
    patchShebangs tests

    # Needs machine-id, comment the test
    sed -e '/\/gdbus\/codegen-peer-to-peer/ s/^\/*/\/\//' -i gio/tests/gdbus-peer.c
    sed -e '/g_test_add_func/ s/^\/*/\/\//' -i gio/tests/gdbus-address-get-session.c
    # All gschemas fail to pass the test, upstream bug?
    sed -e '/g_test_add_data_func/ s/^\/*/\/\//' -i gio/tests/gschema-compile.c
    # Cannot reproduce the failing test_associations on hydra
    sed -e '/\/appinfo\/associations/d' -i gio/tests/appinfo.c
    # Needed because of libtool wrappers
    sed -e '/g_subprocess_launcher_set_environ (launcher, envp);/a g_subprocess_launcher_setenv (launcher, "PATH", g_getenv("PATH"), TRUE);' -i gio/tests/gsubprocess.c
  '' + lib.optionalString stdenv.hostPlatform.isWindows ''
    substituteInPlace gio/win32/meson.build \
      --replace "libintl, " ""
  '';

  postConfigure = ''
    patchShebangs gio/gdbus-2.0/codegen/gdbus-codegen gobject/glib-{genmarshal,mkenums}
  '';

  DETERMINISTIC_BUILD = 1;

  postInstall = ''
    moveToOutput "share/glib-2.0" "$dev"
    moveToOutput "share/glib-2.0/gdb" "$out"
    substituteInPlace "$dev/bin/gdbus-codegen" --replace "$out" "$dev"
    sed -i "$dev/bin/glib-gettextize" -e "s|^gettext_dir=.*|gettext_dir=$dev/share/glib-2.0/gettext|"

    # This file is *included* in gtk3 and would introduce runtime reference via __FILE__.
    sed '1i#line 1 "glib-${finalAttrs.version}/include/glib-2.0/gobject/gobjectnotifyqueue.c"' \
      -i "$dev"/include/glib-2.0/gobject/gobjectnotifyqueue.c
    for i in $bin/bin/*; do
      moveToOutput "share/bash-completion/completions/''${i##*/}" "$bin"
    done
    for i in $dev/bin/*; do
      moveToOutput "share/bash-completion/completions/''${i##*/}" "$dev"
    done
  '';

  preFixup = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    buildPythonPath ${python3Packages.packaging}
    patchPythonScript "$dev/share/glib-2.0/codegen/utils.py"
  '';

  # Move man pages to the same output as their binaries (needs to be
  # done after preFixupHooks which moves man pages too - in
  # _multioutDocs)
  postFixup = ''
    for i in $dev/bin/*; do
      moveToOutput "share/man/man1/''${i##*/}.1.*" "$dev"
    done

    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  nativeCheckInputs = [ tzdata desktop-file-utils shared-mime-info ];

  # Conditional necessary to break infinite recursion with passthru.tests
  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck or config.doCheckByDefault or false ''
    export LD_LIBRARY_PATH="$NIX_BUILD_TOP/glib-${finalAttrs.version}/glib/.libs''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export TZDIR="${tzdata}/share/zoneinfo"
    export XDG_CACHE_HOME="$TMP"
    export XDG_RUNTIME_HOME="$TMP"
    export HOME="$TMP"
    export XDG_DATA_DIRS="${desktop-file-utils}/share:${shared-mime-info}/share"
    export G_TEST_DBUS_DAEMON="${dbus}/bin/dbus-daemon"

    # pkg_config_tests expects a PKG_CONFIG_PATH that points to meson-private, wrapped pkg-config
    # tries to be clever and picks up the wrong glib at the end.
    export PATH="${buildPackages.pkg-config-unwrapped}/bin:$PATH:$(pwd)/gobject"
    echo "PATH=$PATH"

    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that we will delete before installation.
    mkdir -p $out/lib
    ln -s $PWD/gobject/libgobject-${librarySuffix} $out/lib/libgobject-${librarySuffix}
    ln -s $PWD/gio/libgio-${librarySuffix} $out/lib/libgio-${librarySuffix}
    ln -s $PWD/glib/libglib-${librarySuffix} $out/lib/libglib-${librarySuffix}
  '';

  postCheck = ''
    rm $out/lib/libgobject-${librarySuffix}
    rm $out/lib/libgio-${librarySuffix}
    rm $out/lib/libglib-${librarySuffix}
  '';

  separateDebugInfo = stdenv.hostPlatform.isLinux;

  passthru = rec {
    gioModuleDir = "lib/gio/modules";

    makeSchemaDataDirPath = dir: name: "${dir}/share/gsettings-schemas/${name}";
    makeSchemaPath = dir: name: "${makeSchemaDataDirPath dir name}/glib-2.0/schemas";
    getSchemaPath = pkg: makeSchemaPath pkg pkg.name;
    getSchemaDataDirPath = pkg: makeSchemaDataDirPath pkg pkg.name;

    tests = {
      withChecks = finalAttrs.finalPackage.overrideAttrs (_: { doCheck = true; });
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };

    inherit flattenInclude;
    updateScript = gnome.updateScript {
      packageName = "glib";
      versionPolicy = "odd-unstable";
    };

    mkHardcodeGsettingsPatch =
      {
        src,
        glib-schema-to-var,
      }:
      builtins.trace
        "glib.mkHardcodeGsettingsPatch is deprecated, please use makeHardcodeGsettingsPatch instead"
        (makeHardcodeGsettingsPatch {
          inherit src;
          schemaIdToVariableMapping = glib-schema-to-var;
        });
  };

  meta = with lib; {
    description = "C library of programming buildings blocks";
    homepage    = "https://gitlab.gnome.org/GNOME/glib";
    license     = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ lovek323 raskin ]);
    pkgConfigModules = [
      "gio-2.0"
      "gobject-2.0"
      "gthread-2.0"
    ];
    platforms   = platforms.unix ++ platforms.windows;

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';
  };
})
