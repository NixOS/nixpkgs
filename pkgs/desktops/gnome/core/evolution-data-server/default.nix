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
, enableOAuth2 ? stdenv.isLinux
, webkitgtk_4_1
, webkitgtk_5_0
, libaccounts-glib
, json-glib
, glib
, gtk3
, gtk4
, withGtk3 ? true
, withGtk4 ? false
, libphonenumber
, gnome-online-accounts
, libgweather
, boost
, protobuf
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "evolution-data-server";
  version = "3.46.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "xV5yz/QZC0LmPdbqvG3OSKGh95BAUx8a9tUcHvpKpus=";
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
    gnome-online-accounts
    p11-kit
    libgweather
    icu
    sqlite
    libkrb5
    openldap
    glib-networking
    libcanberra-gtk3
    pcre
    libphonenumber
    boost
    protobuf
  ] ++ lib.optionals stdenv.isLinux [
    libaccounts-glib
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ] ++ lib.optionals withGtk3 [
    gtk3
  ] ++ lib.optionals (withGtk3 && enableOAuth2) [
    webkitgtk_4_1
  ] ++ lib.optionals withGtk4 [
    gtk4
  ] ++ lib.optionals (withGtk4 && enableOAuth2) [
    webkitgtk_5_0
  ];

  propagatedBuildInputs = [
    db
    libsecret
    nss
    nspr
    libical
    libsoup_3
    libxml2
    json-glib
  ];

  cmakeFlags = [
    "-DENABLE_UOA=OFF"
    "-DENABLE_VALA_BINDINGS=ON"
    "-DENABLE_INTROSPECTION=ON"
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
    "-DWITH_PHONENUMBER=ON"
    "-DENABLE_GTK=${lib.boolToString withGtk3}"
    "-DENABLE_EXAMPLES=${lib.boolToString withGtk3}"
    "-DENABLE_CANBERRA=${lib.boolToString withGtk3}"
    "-DENABLE_GTK4=${lib.boolToString withGtk4}"
    "-DENABLE_OAUTH2_WEBKITGTK=${lib.boolToString (withGtk3 && enableOAuth2)}"
    "-DENABLE_OAUTH2_WEBKITGTK4=${lib.boolToString (withGtk4 && enableOAuth2)}"
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/modules/SetupBuildFlags.cmake \
      --replace "-Wl,--no-undefined" ""
    substituteInPlace src/services/evolution-alarm-notify/e-alarm-notify.c \
      --replace "G_OS_WIN32" "__APPLE__"
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/${pname}/*.dylib $out/lib/
  '';

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
    platforms = platforms.unix;
  };
}
