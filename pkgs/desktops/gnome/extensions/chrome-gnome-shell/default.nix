{ lib, stdenv
, fetchurl
, cmake
, ninja
, jq
, python3
, gnome
, wrapGAppsHook
, gobject-introspection
}:

let
  inherit (python3.pkgs) python pygobject3 requests;
in
stdenv.mkDerivation rec {
  pname = "chrome-gnome-shell";
  version = "10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/chrome-gnome-shell/${version}/${pname}-${version}.tar.xz";
    sha256 = "0f54xyamm383ypbh0ndkza0pif6ljddg2f947p265fkqj3p4zban";
  };

  nativeBuildInputs = [
    cmake
    ninja
    jq
    wrapGAppsHook
    gobject-introspection # for setup-hook
  ];

  buildInputs = [
    gnome.gnome-shell
    python
    pygobject3
    requests
    gobject-introspection # for Gio typelib
  ];

  cmakeFlags = [
    "-DBUILD_EXTENSION=OFF"
  ];

  wrapPrefixVariables = [
    "PYTHONPATH"
  ];

  # cmake setup hook changes /etc/opt into /var/empty
  dontFixCmake = true;

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace "/etc" "$out/etc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "chrome-gnome-shell";
    };
  };

  meta = with lib; {
    description = "GNOME Shell integration for Chrome";
    homepage = "https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome";
    longDescription = ''
      To use the integration, install the <link xlink:href="https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome/Installation">browser extension</link>, and then set <option>services.gnome.chrome-gnome-shell.enable</option> to <literal>true</literal>.
    '';
    license = licenses.gpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
