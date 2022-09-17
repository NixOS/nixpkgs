{ stdenv
, lib
, fetchurl
, substituteAll
, runCommand
, git
, coccinelle
, pkg-config
, gnome
, _experimental-update-script-combinators
, python3
, gobject-introspection
, gettext
, libsoup_3
, libxml2
, libsecret
, icu
, sqlite
, tzdata
, libcanberra-gtk3
, gcr_4
, p11-kit
, db
, nspr
, nss
, libical
, gperf
, wrapGAppsHook
, glib-networking
, pcre
, vala
, cmake
, ninja
, libkrb5
, openldap
, webkitgtk_4_1
, webkitgtk_5_0
, libaccounts-glib
, json-glib
, glib
, gtk3
, libphonenumber
, gnome-online-accounts
, libgweather
, libgdata
, boost
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "evolution-data-server";
  version = "3.45.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "M0t2QR8hDzcEYDsSpCwU/DKY+hL/6abk+/uYeeP+SyI=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  prePatch = ''
    substitute ${./hardcode-gsettings.patch} hardcode-gsettings.patch \
      --subst-var-by EDS_GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    patches="$patches $PWD/hardcode-gsettings.patch"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gettext
    python3
    gperf
    wrapGAppsHook
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    libsoup_3
    gtk3
    gnome-online-accounts
    gcr_4
    p11-kit
    libgweather
    libgdata
    libaccounts-glib
    json-glib
    icu
    sqlite
    libkrb5
    openldap
    webkitgtk_4_1 # For GTK 3 library
    webkitgtk_5_0 # For GTK 4 library
    glib-networking
    libcanberra-gtk3
    pcre
    libphonenumber
    boost
    protobuf
  ];

  propagatedBuildInputs = [
    db
    libsecret
    nss
    nspr
    libical
    libgdata # needed for GObject inspection, https://gitlab.gnome.org/GNOME/evolution-data-server/-/merge_requests/57/diffs
    libsoup_3
    libxml2
  ];

  cmakeFlags = [
    "-DENABLE_UOA=OFF"
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
    "-DWITH_PHONENUMBER=ON"
    "-DWITH_GWEATHER4=ON"
  ];

  passthru = {
    # In order for GNOME not to depend on OCaml through Coccinelle,
    # we materialize the SmPL patch into a unified diff-style patch.
    hardcodeGsettingsPatch =
      runCommand
        "hardcode-gsettings.patch"
        {
          inherit src;
          nativeBuildInputs = [
            git
            coccinelle
            python3 # For patch script
          ];
        }
        ''
          unpackPhase
          cd "''${sourceRoot:-.}"
          git init
          git add -A
          spatch --sp-file "${./hardcode-gsettings.cocci}" --dir . --in-place
          git diff > "$out"
        '';

    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "evolution-data-server";
          versionPolicy = "odd-unstable";
        };

        updateGsettingsPatch = _experimental-update-script-combinators.copyAttrOutputToFile "evolution-data-server.hardcodeGsettingsPatch" ./hardcode-gsettings.patch;
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateGsettingsPatch
      ];
  };

  meta = with lib; {
    description = "Unified backend for programs that work with contacts, tasks, and calendar information";
    homepage = "https://wiki.gnome.org/Apps/Evolution";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
