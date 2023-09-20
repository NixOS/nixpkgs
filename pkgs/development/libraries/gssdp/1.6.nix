{ stdenv
, lib
, fetchpatch
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, pandoc
, gi-docgen
, python3
, libsoup_3
, glib
, gnome
, gssdp-tools
}:

stdenv.mkDerivation rec {
  pname = "gssdp";
  version = "1.6.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "QQs3be7O2YNrV/SI+ABS/koU+J4HWxzszyjlH0kPn7k=";
  };

  patches = [
    (fetchpatch {
      # https://gitlab.gnome.org/GNOME/gssdp/-/merge_requests/11
      name = "gi-docgen-as-native-dep.patch";
      url = "https://gitlab.gnome.org/GNOME/gssdp/-/commit/db9d02c22005be7e5e81b43a3ab777250bd7b27b.diff";
      hash = "sha256-Q2kwZlpNvSzIcMalrOm5lO5iFe+myS7J0S0vkcp10cw=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    pandoc
    gi-docgen
    python3
  ];

  buildInputs = [
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dsniffer=false"
  ];

  doCheck = true;

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
      | while IFS= read -r -d ''' file; do
        moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gssdp_1_6";
      packageName = pname;
    };

    tests = {
      inherit gssdp-tools;
    };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.all;
  };
}
