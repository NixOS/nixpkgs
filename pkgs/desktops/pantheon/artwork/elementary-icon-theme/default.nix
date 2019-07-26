{ stdenv, fetchFromGitHub, pantheon, meson, python3,ninja, hicolor-icon-theme, gtk3 }:

stdenv.mkDerivation rec {
  pname = "icons";
  version = "5.0.4";

  name = "elementary-icon-theme-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0ha7biqvmkv68x1gi9bfcn5z0ld067pa5czx0pyf053pa86lg3hx";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-icon-theme";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  mesonFlags = [
    "-Dvolume_icons=false" # Tries to install some icons to /
    "-Dpalettes=false" # Don't install gimp and inkscape palette files
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs meson/symlink.py
  '';

  postFixup = "gtk-update-icon-cache $out/share/icons/elementary";

  meta = with stdenv.lib; {
    description = "Named, vector icons for elementary OS";
    longDescription = ''
      An original set of vector icons designed specifically for elementary OS and its desktop environment: Pantheon.
    '';
    homepage = https://github.com/elementary/icons;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
