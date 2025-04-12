{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, makeWrapper
, pkg-config
, libxslt
, meson
, ninja
, python3
, dbus
, umockdev
, libeatmydata
, gtk-doc
, docbook-xsl-nons
, udev
, libgudev
, libusb1
, glib
, gettext
, nixosTests
, useIMobileDevice ? true
, libimobiledevice
, withDocs ? withIntrospection
, mesonEmulatorHook
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, buildPackages
, gobject-introspection
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
}:

assert withDocs -> withIntrospection;

stdenv.mkDerivation (finalAttrs: {
  pname = "upower";
  version = "1.90.4";

  outputs = [ "out" "dev" ]
    ++ lib.optionals withDocs [ "devdoc" ]
    ++ lib.optionals withIntrospection [ "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "upower";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5twHuDLisVF07Y5KYwlqWMi12+p6UpARJvoBN/+tX2o=";
  };

  patches = lib.optionals (stdenv.hostPlatform.system == "i686-linux") [
    # Remove when this is fixed upstream:
    # https://gitlab.freedesktop.org/upower/upower/-/issues/214
    ./i686-test-remove-battery-check.patch
  ] ++ [
    ./installed-tests-path.patch

    # Fix a race condition in test_sibling_priority_no_overwrite
    # Remove when updating to > 1.90.6
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/upower/upower/-/commit/9ee76826bd41a5d3a377dfd6f5835f42ec50be9a.patch";
      hash = "sha256-E56iz/iHn+VM7Opo0a13A5nhnB9nf6C7Y1kyWzk4ZnU=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
    docbook-xsl-nons
    gettext
    libxslt
    makeWrapper
    pkg-config
    glib
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals withDocs [
    gtk-doc
  ] ++ lib.optionals (withDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    libgudev
    libusb1
    udev
  ] ++ lib.optionals withIntrospection [
    # Duplicate from nativeCheckInputs until https://github.com/NixOS/nixpkgs/issues/161570 is solved
    umockdev

    # For installed tests.
    (python3.withPackages (pp: [
      pp.dbus-python
      pp.python-dbusmock
      pp.pygobject3
      pp.packaging
    ]))
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ lib.optionals useIMobileDevice [
    libimobiledevice
  ];

  nativeCheckInputs = [
    libeatmydata
  ] ++ lib.optionals withIntrospection [
    python3.pkgs.dbus-python
    python3.pkgs.python-dbusmock
    python3.pkgs.pygobject3
    dbus
    umockdev
    python3.pkgs.packaging
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Dos_backend=linux"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "-Dudevhwdbdir=${placeholder "out"}/lib/udev/hwdb.d"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonBool "gtk-doc" withDocs)
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs src/linux/integration-test.py
    patchShebangs src/linux/unittest_inspector.py

    substituteInPlace src/linux/integration-test.py \
      --replace "/usr/share/dbus-1" "$out/share/dbus-1"
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    mkdir -p "$out/lib"
    ln -s "$PWD/libupower-glib/libupower-glib.so" "$out/lib/libupower-glib.so.3"
  '';

  checkPhase = ''
    runHook preCheck

    # Slow fsync calls can make self-test fail:
    # https://gitlab.freedesktop.org/upower/upower/-/issues/195
    eatmydata meson test --print-errorlogs

    runHook postCheck
  '';

  postCheck = ''
    # Undo patchShebangs from postPatch so that it can be replaced with runtime shebang
    # unittest_inspector.py intentionally not reverted because it would trigger
    # meson rebuild during install and it is not used at runtime anyway.
    sed -Ei 's~#!.+/bin/python3~#!/usr/bin/python3~' \
      ../src/linux/integration-test.py

    # Undo preCheck installation since DESTDIR hack expects outputs to not exist.
    rm "$out/lib/libupower-glib.so.3"
    rmdir "$out/lib" "$out"
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    for o in $(getAllOutputNames); do
        # devdoc is created later by _multioutDocs hook.
        if [[ "$o" = "devdoc" ]]; then continue; fi
        mv "$DESTDIR''${!o}" "$(dirname "''${!o}")"
    done

    mv "$DESTDIR/var" "$out"
    # The /etc already exist so we need to merge it.
    cp --recursive "$DESTDIR/etc" "$out"
    rm --recursive "$DESTDIR/etc"

    # Ensure we did not forget to install anything.
    rmdir --parents --ignore-fail-on-non-empty "$DESTDIR${builtins.storeDir}"
    ! test -e "$DESTDIR"
  '';

  postFixup = lib.optionalString withIntrospection ''
    wrapProgram "$installedTests/libexec/upower/integration-test.py" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [
        "$out"
        umockdev.out
      ]}" \
      --prefix PATH : "${lib.makeBinPath [
        umockdev
      ]}"
  '';

  env = {
    # HACK: We want to install configuration files to $out/etc
    # but upower should read them from /etc on a NixOS system.
    # With autotools, it was possible to override Make variables
    # at install time but Meson does not support this
    # so we need to convince it to install all files to a temporary
    # location using DESTDIR and then move it to proper one in postInstall.
    DESTDIR = "dest";
  };

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.upower;
    };
  };

  meta = with lib; {
    homepage = "https://upower.freedesktop.org/";
    changelog = "https://gitlab.freedesktop.org/upower/upower/-/blob/v${finalAttrs.version}/NEWS";
    description = "D-Bus service for power management";
    mainProgram = "upower";
    maintainers = teams.freedesktop.members;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
})
