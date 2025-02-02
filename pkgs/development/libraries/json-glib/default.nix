{ lib
, stdenv
, fetchurl
, glib
, meson
, ninja
, nixosTests
, pkg-config
, gettext
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, buildPackages
, gobject-introspection
, gi-docgen
, libxslt
, fixDarwinDylibNames
, gnome
}:

stdenv.mkDerivation rec {
  pname = "json-glib";
  version = "1.8.0";

  outputs = [ "out" "dev" "installedTests" ]
    ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "l+9euSyoEQOa1Qpl8GYz8armR5J4kwe+cXB5XYsxlFQ=";
  };

  patches = [
    # Add option for changing installation path of installed tests.
    ./meson-add-installed-tests-prefix-option.patch
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
    libxslt
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    gi-docgen
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "gtk_doc" withIntrospection)
  ];

  # Run-time dependency gi-docgen found: NO (tried pkgconfig and cmake)
  # it should be a build-time dep for build
  # TODO: send upstream
  postPatch = ''
    substituteInPlace doc/meson.build \
      --replace "'gi-docgen', ver" "'gi-docgen', native:true, ver" \
      --replace "'gi-docgen', req" "'gi-docgen', native:true, req"
  '';

  doCheck = true;

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    if [[ -d "$out/share/doc" ]]; then
        find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
          | while IFS= read -r -d ''' file; do
            moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
        done
    fi
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.json-glib;
    };

    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    homepage = "https://gitlab.gnome.org/GNOME/json-glib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = with platforms; unix;
  };
}
