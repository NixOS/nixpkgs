{stdenv, fetchurl, cmake, ninja, jq, python3, gnome3, wrapGAppsHook}:

let
  version = "10.1";

  inherit (python3.pkgs) python pygobject3 requests;
in stdenv.mkDerivation rec {
  name = "chrome-gnome-shell-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/chrome-gnome-shell/${version}/${name}.tar.xz";
    sha256 = "0f54xyamm383ypbh0ndkza0pif6ljddg2f947p265fkqj3p4zban";
  };

  nativeBuildInputs = [ cmake ninja jq wrapGAppsHook ];
  buildInputs = [ gnome3.gnome-shell python pygobject3 requests ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace "/etc" "$out/etc"
  '';
  # cmake setup hook changes /etc/opt into /var/empty
  dontFixCmake = true;

  cmakeFlags = [ "-DBUILD_EXTENSION=OFF" ];
  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "chrome-gnome-shell";
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME Shell integration for Chrome";
    homepage = https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome;
    longDescription = ''
      To use the integration, install the <link xlink:href="https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome/Installation">browser extension</link>, and then set <option>services.gnome3.chrome-gnome-shell.enable</option> to <literal>true</literal>. For Firefox based browsers, you will also need to build the wrappers with <option>nixpkgs.config.firefox.enableGnomeExtensions</option> set to <literal>true</literal>.
    '';
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
