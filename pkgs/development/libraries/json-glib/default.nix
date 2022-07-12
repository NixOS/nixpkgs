{ lib
, stdenv
, fetchurl
, glib
, meson
, ninja
, pkg-config
, gettext
, gobject-introspection
, gi-docgen
, libxslt
, fixDarwinDylibNames
, gnome
}:

stdenv.mkDerivation rec {
  pname = "json-glib";
  version = "1.6.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "luyYvnqR9t3jNjZyDj2i/27LuQ52zKpJSX8xpoVaSQ4=";
  };

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
    gobject-introspection
    gi-docgen
  ] ++ lib.optional stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [
    glib
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
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    homepage = "https://wiki.gnome.org/Projects/JsonGlib";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = with platforms; unix;
  };
}
