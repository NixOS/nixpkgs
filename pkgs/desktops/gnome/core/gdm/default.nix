{ lib, stdenv
, fetchurl
, fetchpatch
, substituteAll
, meson
, ninja
, python3
, rsync
, pkg-config
, glib
, itstool
, libxml2
, xorg
, accountsservice
, libX11
, gnome
, systemd
, dconf
, gtk3
, libcanberra-gtk3
, pam
, libgudev
, libselinux
, keyutils
, audit
, gobject-introspection
, plymouth
, librsvg
, coreutils
, xorgserver
, xwayland
, dbus
, nixos-icons
}:

let

  override = substituteAll {
    src = ./org.gnome.login-screen.gschema.override;
    icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
  };

in

stdenv.mkDerivation rec {
  pname = "gdm";
  version = "42.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "oyisl2k3vsF5lx/weCmhJGuYznJBgcEorjKguketOFU=";
  };

  mesonFlags = [
    "-Dgdm-xsession=true"
    # TODO: Setup a default-path? https://gitlab.gnome.org/GNOME/gdm/-/blob/6fc40ac6aa37c8ad87c32f0b1a5d813d34bf7770/meson_options.txt#L6
    "-Dinitial-vt=${passthru.initialVT}"
    "-Dudev-dir=${placeholder "out"}/lib/udev/rules.d"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  nativeBuildInputs = [
    dconf
    glib # for glib-compile-schemas
    itstool
    meson
    ninja
    pkg-config
    python3
    rsync
  ];

  buildInputs = [
    accountsservice
    audit
    glib
    gobject-introspection
    gtk3
    keyutils
    libX11
    libcanberra-gtk3
    libgudev
    libselinux
    pam
    plymouth
    systemd
    xorg.libXdmcp
  ];

  patches = [
    # GDM fails to find g-s with the following error in the journal.
    # gdm-x-session[976]: dbus-run-session: failed to exec 'gnome-session': No such file or directory
    # https://gitlab.gnome.org/GNOME/gdm/-/merge_requests/92
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gdm/-/commit/ccecd9c975d04da80db4cd547b67a1a94fa83292.patch";
      sha256 = "5hKS9wjjhuSAYwXct5vS0dPbmPRIINJoLC0Zm1naz6Q=";
      revert = true;
    })

    # Change hardcoded paths to nix store paths.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils plymouth xorgserver xwayland dbus;
    })

    # The following patches implement certain environment variables in GDM which are set by
    # the gdm configuration module (nixos/modules/services/x11/display-managers/gdm.nix).

    ./gdm-x-session_extra_args.patch

    # Allow specifying a wrapper for running the session command.
    ./gdm-x-session_session-wrapper.patch

    # Forwards certain environment variables to the gdm-x-session child process
    # to ensure that the above two patches actually work.
    ./gdm-session-worker_forward-vars.patch

    # Set up the environment properly when launching sessions
    # https://github.com/NixOS/nixpkgs/issues/48255
    ./reset-environment.patch
  ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py

    # Upstream checks some common paths to find an `X` binary. We already know it.
    echo #!/bin/sh > build-aux/find-x-server.sh
    echo "echo ${lib.getBin xorg.xorgserver}/bin/X" >> build-aux/find-x-server.sh
    patchShebangs build-aux/find-x-server.sh
  '';

  preInstall = ''
    install -D ${override} ${DESTDIR}/$out/share/glib-2.0/schemas/org.gnome.login-screen.gschema.override
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    # We use rsync to merge the directories.
    rsync --archive "${DESTDIR}/etc" "$out"
    rm --recursive "${DESTDIR}/etc"
    for o in $outputs; do
        if [[ "$o" = "debug" ]]; then continue; fi
        rsync --archive "${DESTDIR}/''${!o}" "$(dirname "''${!o}")"
        rm --recursive "${DESTDIR}/''${!o}"
    done
    # Ensure the DESTDIR is removed.
    rmdir "${DESTDIR}/nix/store" "${DESTDIR}/nix" "${DESTDIR}"

    # We are setting DESTDIR so the post-install script does not compile the schemas.
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  # HACK: We want to install configuration files to $out/etc
  # but GDM should read them from /etc on a NixOS system.
  # With autotools, it was possible to override Make variables
  # at install time but Meson does not support this
  # so we need to convince it to install all files to a temporary
  # location using DESTDIR and then move it to proper one in postInstall.
  DESTDIR = "${placeholder "out"}/dest";

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gdm";
      attrPath = "gnome.gdm";
    };

    # Used in GDM NixOS module
    # Don't remove.
    initialVT = "7";
  };

  meta = with lib; {
    description = "A program that manages graphical display servers and handles graphical user logins";
    homepage = "https://wiki.gnome.org/Projects/GDM";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
