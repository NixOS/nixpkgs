{ config
, lib
, stdenv
, fetchurl
, fetchpatch
, gettext
, meson
, ninja
, pkg-config
, perl
, python3
, libiconv, zlib, libffi, pcre2, libelf, gnome, libselinux, bash, gnum4, gtk-doc, docbook_xsl, docbook_xml_dtd_45, libxslt
# use util-linuxMinimal to avoid circular dependency (util-linux, systemd, glib)
, util-linuxMinimal ? null
, buildPackages

# this is just for tests (not in the closure of any regular package)
, coreutils, dbus, libxml2, tzdata
, desktop-file-utils, shared-mime-info
, darwin
, makeHardcodeGsettingsPatch
}:

assert stdenv.isLinux -> util-linuxMinimal != null;

# TODO:
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved
/*
  * Use --enable-installed-tests for GNOME-related packages,
      and use them as a separately installed tests run by Hydra
      (they should test an already installed package)
      https://wiki.gnome.org/GnomeGoals/InstalledTests
  * Support org.freedesktop.Application, including D-Bus activation from desktop files
*/
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

  buildDocs = stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isStatic;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "glib";
  version = "2.74.3";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${lib.versions.majorMinor finalAttrs.version}/glib-${finalAttrs.version}.tar.xz";
    sha256 = "6bxB7NlpDZvGqXDMc4ARm4KOW2pLFsOTxjiz3CuHy8s=";
  };

  patches = lib.optionals stdenv.isDarwin [
    ./darwin-compilation.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    ./quark_init_on_demand.patch
    ./gobject_init_on_demand.patch

    # Fix error about missing sentinel in glib/tests/cxx.cpp
    # These two commits are part of already merged glib MRs 3033 and 3031:
    # https://gitlab.gnome.org/GNOME/glib/-/merge_requests/3033
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/glib/-/commit/0ca5254c5d92aec675b76b4bfa72a6885cde6066.patch";
      sha256 = "OfD5zO/7JIgOMLc0FAgHV9smWugFJuVPHCn9jTsMQJg=";
    })
    # https://gitlab.gnome.org/GNOME/glib/-/merge_requests/3031
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/glib/-/commit/7dc19632f3115e3f517c6bc80436fe72c1dcdeb4.patch";
      sha256 = "v28Yk+R0kN9ssIcvJudRZ4vi30rzQEE8Lsd1kWp5hbM=";
    })
  ] ++ [
    ./glib-appinfo-watch.patch
    ./schema-override-variable.patch

    # Add support for the GNOME’s default terminal emulator.
    # https://gitlab.gnome.org/GNOME/glib/-/issues/2618
    ./gnome-console-support.patch
    # Do the same for Pantheon’s terminal emulator.
    ./elementary-terminal-support.patch

    # GLib contains many binaries used for different purposes;
    # we will install them to different outputs:
    # 1. Tools for desktop environment ($bin)
    #    * gapplication (non-darwin)
    #    * gdbus
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

    # Disable flaky test.
    # https://gitlab.gnome.org/GNOME/glib/-/issues/820
    ./skip-timer-test.patch

    # GVariant security fixes
    # https://discourse.gnome.org/t/multiple-fixes-for-gvariant-normalisation-issues-in-glib/12835
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/glib/-/merge_requests/3126.patch";
      sha256 = "CNCxouYy8xNHt4eJtPZ2eOi9b0SxzI2DkklNfQMk3d8=";
    })

    # Menu model security fix
    # https://discourse.gnome.org/t/fixes-for-gdbusmenumodel-crashes-in-glib/12846
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/glib/-/commit/4f4d770a1e40f719d5a310cffdac29cbb4e20c11.patch";
      sha256 = "+S44AnC86HfbMwkRe1ll54IK9pLxaFD3LqiVhPelnXI=";
    })
  ];

  outputs = [ "bin" "out" "dev" "devdoc" ];

  setupHook = ./setup-hook.sh;

  buildInputs = [
    libelf
    finalAttrs.setupHook
    pcre2
  ] ++ lib.optionals (!stdenv.hostPlatform.isWindows) [
    bash gnum4 # install glib-gettextize and m4 macros for other apps to use
  ] ++ lib.optionals stdenv.isLinux [
    libselinux
    util-linuxMinimal # for libmount
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit Carbon Cocoa CoreFoundation CoreServices Foundation
  ]) ++ lib.optionals buildDocs [
    # Note: this needs to be both in buildInputs and nativeBuildInputs. The
    # Meson gtkdoc module uses find_program to look it up (-> build dep), but
    # glib's own Meson configuration uses the host pkg-config to find its
    # version (-> host dep). We could technically go and fix this in glib, add
    # pkg-config to depsBuildBuild, but this would be a futile exercise since
    # Meson's gtkdoc integration does not support cross compilation[1] anyway
    # and this derivation disables the docs build when cross compiling.
    #
    # [1] https://github.com/mesonbuild/meson/issues/2003
    gtk-doc
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    perl
    python3
    gettext
    libxslt
    docbook_xsl
  ] ++ lib.optionals buildDocs [
    gtk-doc
    docbook_xml_dtd_45
    libxml2
  ];

  propagatedBuildInputs = [ zlib libffi gettext libiconv ];

  mesonFlags = [
    # Avoid the need for gobject introspection binaries in PATH in cross-compiling case.
    # Instead we just copy them over from the native output.
    "-Dgtk_doc=${lib.boolToString buildDocs}"
    "-Dnls=enabled"
    "-Ddevbindir=${placeholder "dev"}/bin"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-Dman=true"                # broken on Darwin
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=nonnull"
    # Default for release buildtype but passed manually because
    # we're using plain
    "-DG_DISABLE_CAST_CHECKS"
  ];

  postPatch = ''
    chmod +x gio/tests/gengiotypefuncs.py
    patchShebangs gio/tests/gengiotypefuncs.py
    chmod +x docs/reference/gio/concat-files-helper.py
    patchShebangs docs/reference/gio/concat-files-helper.py
    patchShebangs glib/gen-unicode-tables.pl
    patchShebangs glib/tests/gen-casefold-txt.py
    patchShebangs glib/tests/gen-casemap-txt.py

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
  '' + lib.optionalString (!buildDocs) ''
    cp -r ${buildPackages.glib.devdoc} $devdoc
  '';

  # Move man pages to the same output as their binaries (needs to be
  # done after preFixupHooks which moves man pages too - in
  # _multioutDocs)
  postFixup = ''
    for i in $dev/bin/*; do
      moveToOutput "share/man/man1/''${i##*/}.1.*" "$dev"
    done
  '';

  checkInputs = [ tzdata desktop-file-utils shared-mime-info ];

  preCheck = lib.optionalString finalAttrs.doCheck or config.doCheckByDefault or false ''
    export LD_LIBRARY_PATH="$NIX_BUILD_TOP/glib-${finalAttrs.version}/glib/.libs''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export TZDIR="${tzdata}/share/zoneinfo"
    export XDG_CACHE_HOME="$TMP"
    export XDG_RUNTIME_HOME="$TMP"
    export HOME="$TMP"
    export XDG_DATA_DIRS="${desktop-file-utils}/share:${shared-mime-info}/share"
    export G_TEST_DBUS_DAEMON="${dbus}/bin/dbus-daemon"
    export PATH="$PATH:$(pwd)/gobject"
    echo "PATH=$PATH"
  '';

  separateDebugInfo = stdenv.isLinux;

  passthru = rec {
    gioModuleDir = "lib/gio/modules";

    makeSchemaDataDirPath = dir: name: "${dir}/share/gsettings-schemas/${name}";
    makeSchemaPath = dir: name: "${makeSchemaDataDirPath dir name}/glib-2.0/schemas";
    getSchemaPath = pkg: makeSchemaPath pkg pkg.name;
    getSchemaDataDirPath = pkg: makeSchemaDataDirPath pkg pkg.name;

    tests.withChecks = finalAttrs.finalPackage.overrideAttrs (_: { doCheck = true; });

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
    homepage    = "https://www.gtk.org/";
    license     = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ lovek323 raskin ]);
    platforms   = platforms.unix;

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';
  };
})
